resource "aws_db_subnet_group" "subnet_database" {
  name       = "subnet-group-rds"
  subnet_ids = ["${aws_subnet.subnets_asociated_wg["cidr_public_a_vpc_3"].id}", "${aws_subnet.subnets_asociated_wg["cidr_public_b_vpc_3"].id}"]
  tags = {
    Name = "Subnet group - database cloud"
  }
}

resource "aws_security_group" "security_rds_db" {
  name        = "cloud-database-sg"
  description = "Habilita el acceso a la bd"

  vpc_id = aws_vpc.vpc_tech_cloud_worshop_g["vpc_3"].id


  ingress {
    cidr_blocks = [
      "172.31.0.0/16"
    ]
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
  }



}

resource "aws_db_instance" "maria_db_motor" {
  db_name                = "cloud_bd"
 # parameter_group_name   = "mariadb_clud_bd"
  db_subnet_group_name   = aws_db_subnet_group.subnet_database.name
  storage_type           = "gp2"
  network_type           = "IPV4"
  allocated_storage      = 20
  vpc_security_group_ids = ["${aws_security_group.security_rds_db.id}"]
  engine                 = "MariaDB"
  instance_class         = "db.t3.micro"
  username               = "monicaadmin"
  password               = "monicaadmin"
  publicly_accessible    = false
  port                   = 3306
  skip_final_snapshot    = true // required to destroy
}