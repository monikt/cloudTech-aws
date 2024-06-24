#vpc-017114eb240aac67e
/*
resource "aws_s3_bucket" "s3_buckets" {
  for_each = toset(var.prefix_buckets)
  bucket   = each.value
}
resource "aws_iam_role" "ec2_role" {
  name               = "sbx-${local.account_id}-ec2-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2.json
}
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "sbx-${local.account_id}-ec2-aws_iam_instance_profile"
  role = aws_iam_role.ec2_role.name
}


resource "aws_iam_policy" "policy_ec2_s3" {
  for_each    = aws_s3_bucket.s3_buckets
  name        = "police-${each.value.id}"
  path        = "/"
  description = "Police using for dev users"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = templatefile("${path.module}/policy_allow_s3_object.tpl", {
    stage         = "sbx"
    bucket_s3_arn = "${each.value.arn}"
  })

}

resource "aws_iam_role_policy_attachment" "attach_police_ec2_s3" {
  for_each   = aws_iam_policy.policy_ec2_s3
  policy_arn = each.value.arn
  role       = aws_iam_role.ec2_role.name
}
*/

resource "aws_security_group" "security_public" {
  name        = "web-server-sg"
  description = "Habilita puertos para aplicaciones web"

  vpc_id = aws_vpc.vpc_tech_cloud_worshop_g["vpc_3"].id


  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*

resource "aws_security_group" "security_group_private" {
  name = "ec2-machine-private-sg"

  vpc_id = aws_vpc.vpc_tech_cloud_worshop_g.id

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }


  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

sudo dnf install mariadb105
*/

resource "tls_private_key" "tls_priv_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "ec2-monica-lab"
  public_key = tls_private_key.tls_priv_key.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.generated_key.key_name}.pem"
  content  = tls_private_key.tls_priv_key.private_key_pem

}
resource "aws_instance" "ec2_sbx" {
  ami           = "ami-07caf09b362be10b8"
  instance_type = "t2.micro"

  key_name        = aws_key_pair.generated_key.key_name
  security_groups = ["${aws_security_group.security_public.id}"]
  #associate_public_ip_address = true
  subnet_id = aws_subnet.subnets_asociated_wg["cidr_public_a_vpc_3"].id
  # iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  user_data = <<-EOL
  #!/bin/bash
  yum update -y
  yum install -y httpd
  systemctl start httpd
  systemctl enable httpd
  echo "<h1>Mi webserver en $(hostname -f)<h1>" > /var/www/html/index.html
  EOL
  tags = {
    Name = "${local.account_id}-web-server-aws-public_1"
  }
}

resource "aws_instance" "ec2_sbx_machine_2" {
  ami           = "ami-07caf09b362be10b8"
  instance_type = "t2.micro"

  key_name        = aws_key_pair.generated_key.key_name
  security_groups = ["${aws_security_group.security_public.id}"]
  #associate_public_ip_address = true
  subnet_id = aws_subnet.subnets_asociated_wg["cidr_public_b_vpc_3"].id
  #iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  user_data = <<-EOL
  #!/bin/bash
  yum update -y
  yum install -y httpd
  systemctl start httpd
  systemctl enable httpd
  echo "<h1>Mi webserver en $(hostname -f)<h1>" > /var/www/html/index.html
  EOL
  tags = {
    Name = "${local.account_id}-web-server-aws-public-2"
  }
}
/*

resource "aws_instance" "ec2_sbx_machine_3" {
  ami           = "ami-07caf09b362be10b8"
  instance_type = "t2.micro"

  key_name        = aws_key_pair.generated_key.key_name
  security_groups = ["sg-06c50ba643825acf0"]
  #associate_public_ip_address = true
  subnet_id            = aws_subnet.subnets_asociated_wg["cidr_public_b_vpc_3"].id
  #iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  user_data  = <<-EOL
  #!/bin/bash
  yum update -y
  yum install -y httpd
  systemctl start httpd
  systemctl enable httpd
  echo "<h1>Mi webserver en $(hostname -f)<h1>" > /var/www/html/index.html
  EOL
  tags = {
    Name = "${local.account_id}-web-server-aws-public-3"
  }
}


resource "aws_instance" "ec2_sbx_machine_4" {
  ami           = "ami-07caf09b362be10b8"
  instance_type = "t2.micro"

  key_name        = aws_key_pair.generated_key.key_name
  security_groups = ["sg-06c50ba643825acf0"]
 #associate_public_ip_address = true
  subnet_id            = aws_subnet.subnets_asociated_wg["cidr_public_b_vpc_3"].id
  #iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  user_data  = <<-EOL
  #!/bin/bash
  yum update -y
  yum install -y httpd
  systemctl start httpd
  systemctl enable httpd
  echo "<h1>Mi webserver en $(hostname -f)<h1>" > /var/www/html/index.html
  EOL
  tags = {
    Name = "${local.account_id}-web-server-aws-public-4"
  }
}

*/


output "private_key" {
  value     = tls_private_key.tls_priv_key.private_key_pem
  sensitive = true
}