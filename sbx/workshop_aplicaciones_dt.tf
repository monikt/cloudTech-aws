//TODO 
/*
1. Create Dynamo CreditRequestTable and police que permita a una funcion labda hacer un insert 
2. Create lambda calls fnCreditRequest para que su funcionalidad sea hacer un insert en la tabla dynamo
3. codigo lambda que permita diferenciar si es una peticion de TC_Request o CL_Request y conforme a ello llamar a la cola correspondiente
4. Creacion de cola sqsTCLambdaValidation para enviar un mensaje hacia la lamba fnTCRequestValidation
5. Creacion de cola sqsCLLambdaValidation para enviar un mensaje hacia la lamba fnCLRequestValidation

*/


/* dynamo */


resource "aws_dynamodb_table" "db_credit_request_table" {
  name           = "CreditRequestTable"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "CreditRequestTable"
    Environment = "sbx"
  }
}

/* fnCreditRequest lambda */

data "archive_file" "code_fnCreditRequest" {
  type        = "zip"
  source_dir  = "${path.module}/fnCreditRequest"
  output_path = "lambda_fnCreditRequest.zip"
}

data "aws_iam_policy_document" "assume_role_labda" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda_execution"
  assume_role_policy = data.aws_iam_policy_document.assume_role_labda.json
}


//TODO falta policie
resource "aws_iam_policy" "policie_acces_dynamo" {
  name = "dynamo_police_acces"

  description = "Politica de acceso para integracion entre lambda y dynamo"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
        ]
        Effect   = "Allow"
        Resource = "${aws_dynamodb_table.db_credit_request_table.arn}"
      },
    ]
  })

}


resource "aws_iam_policy" "policie_acces_cloudwacht" {
  name = "cloudwacht_access_lambda"

  description = "Politica de acceso para integracion entre lambda y logs"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:us-east-1:654654318411:*"
      },
    ]
  })

}

resource "aws_iam_policy" "policie_acces_sqs" {
  name = "sqs_access_lambda"

  description = "Politica de acceso para integracion entre lambda y sqs"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "test" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.policie_acces_dynamo.arn
}

resource "aws_iam_role_policy_attachment" "test_2" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.policie_acces_cloudwacht.arn
}

resource "aws_iam_role_policy_attachment" "test_3" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.policie_acces_sqs.arn
}

resource "aws_lambda_function" "func1" {
  filename         = "lambda_fnCreditRequest.zip"
  function_name    = "fnCreditRequest"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.code_fnCreditRequest.output_base64sha256
  runtime          = "nodejs18.x"
}


/********************************************************************/
/************* sqs ***********************************/
/********************************************************************/

resource "aws_sqs_queue" "queue_tcl_validation" {
  name                       = "sqsTCLambdaValidation"
  delay_seconds              = 10
  visibility_timeout_seconds = 30
  max_message_size           = 2048
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 2
  sqs_managed_sse_enabled    = true

}


resource "aws_sqs_queue" "queue_cll_validation" {
  name                       = "sqsCLLambdaValidation"
  delay_seconds              = 10
  visibility_timeout_seconds = 30
  max_message_size           = 2048
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 2
  sqs_managed_sse_enabled    = true
}



