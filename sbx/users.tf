/*resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/users/"
}

resource "aws_iam_group" "analytics" {
  name = "analytics"
  path = "/users/"
}

resource "aws_iam_group" "tecnical_leaders" {
  name = "tecnical_leaders"
  path = "/users/"
}

resource "aws_iam_group" "qa" {
  name = "qa"
  path = "/users/"
}

resource "aws_iam_user" "users_for_developers" {
  for_each = var.users_for_developer
  name     = join("-", [each.value], [each.key])
  path     = "/users/"
}


resource "aws_iam_user_group_membership" "relations-group-developers" {
  for_each = var.users_for_developer
  user     = aws_iam_user.users_for_developers[each.key].name
  groups = [
    aws_iam_group.developers.name
  ]
}


resource "aws_iam_user" "users_for_analytics" {
  for_each = var.users_for_analytics
  name     = join("-", [each.value], [each.key])
  path     = "/users/"
}


resource "aws_iam_user_group_membership" "relations-group-analytics" {
  for_each = var.users_for_analytics
  user     = aws_iam_user.users_for_analytics[each.key].name
  groups = [
    aws_iam_group.analytics.name
  ]
}


resource "aws_iam_user" "users_for_qa" {
  for_each = var.users_for_qa
  name     = join("-", [each.value], [each.key])
  path     = "/users/"
}


resource "aws_iam_user_group_membership" "relations-group-qa" {
  for_each = var.users_for_qa
  user     = aws_iam_user.users_for_qa[each.key].name
  groups = [
    aws_iam_group.qa.name
  ]
}


resource "aws_iam_user_group_membership" "relations-group-tecnical_leader_1" {
  user = aws_iam_user.users_for_qa["qa_1"].name
  groups = [
    aws_iam_group.tecnical_leaders.name
  ]
}


resource "aws_iam_user_group_membership" "relations-group-tecnical_leader_2" {
  user = aws_iam_user.users_for_analytics["analityc_1"].name
  groups = [
    aws_iam_group.tecnical_leaders.name
  ]
}

resource "aws_iam_user_group_membership" "relations-group-tecnical_leader_3" {
  user = aws_iam_user.users_for_developers["dev2"].name
  groups = [
    aws_iam_group.tecnical_leaders.name
  ]
}

resource "aws_iam_policy" "policy_dev_users" {
  name        = "eec-aws-co-police-dev-user"
  path        = "/"
  description = "Police using for dev users"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = templatefile("${path.module}/policy_allow_dev.tpl", {
    stage   = "sbx"
    ec2_arn = "${aws_instance.ec2_sbx.arn}"
  })

}

resource "aws_iam_user_policy_attachment" "attach-police-dev" {
  for_each   = var.users_for_developer
  user       = aws_iam_user.users_for_developers[each.key].name
  policy_arn = aws_iam_policy.policy_dev_users.arn
}

resource "aws_iam_policy" "policy_analityc_users" {
  name        = "eec-aws-co-police-analityc-users"
  path        = "/"
  description = "Police using for analityc users"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = templatefile("${path.module}/policy_allow_analitica.tpl", {
    stage   = "sbx"
    ec2_arn = "${aws_instance.ec2_sbx.arn}"
  })

}

resource "aws_iam_user_policy_attachment" "attach-police-analityc" {
  for_each   = var.users_for_analytics
  user       = aws_iam_user.users_for_analytics[each.key].name
  policy_arn = aws_iam_policy.policy_analityc_users.arn
}

resource "aws_iam_policy" "policy_tecnical_leader_users" {
  name        = "eec-aws-co-police-tecnical-leaders-users"
  path        = "/"
  description = "Police using for tecnical leaders users"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = templatefile("${path.module}/policy_allow_lideres_tecnicos.tpl", {
    stage   = "sbx"
    ec2_arn = "${aws_instance.ec2_sbx.arn}"
  })

}

resource "aws_iam_user_policy_attachment" "attach_police_tecnical" {
  user       = aws_iam_user.users_for_qa["qa_1"].name
  policy_arn = aws_iam_policy.policy_tecnical_leader_users.arn
}

resource "aws_iam_user_policy_attachment" "attach_police_tecnical_1" {
  user       = aws_iam_user.users_for_analytics["analityc_1"].name
  policy_arn = aws_iam_policy.policy_tecnical_leader_users.arn
}

resource "aws_iam_user_policy_attachment" "attach_police_tecnical_2" {
  user       = aws_iam_user.users_for_developers["dev2"].name
  policy_arn = aws_iam_policy.policy_tecnical_leader_users.arn
}*/
