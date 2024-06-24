resource "aws_vpc" "vpc_tech_cloud_worshop_g" {
  for_each             = var.cidrs_available_vpce_worshop_g
  cidr_block           = each.value.cidr_vpce
  enable_dns_support   = true
  enable_dns_hostnames = true #gives you an internal host name
  instance_tenancy     = "default"
  tags = {
    Name = "${each.value.vpc_name}_${var.stage}"
  }

}

# Create four subnets 
resource "aws_subnet" "subnets_asociated_wg" {

  for_each                = var.cidrs_available_subnet_worshop_g
  vpc_id                  = aws_vpc.vpc_tech_cloud_worshop_g["${each.value.vpc_identificator}"].id
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = strcontains(each.key, "public") ? true : false
  availability_zone       = each.value.zona_valida
  tags = {
    Name = "vpc_tech_cloud_wg_${each.key}_${each.value.vpc_identificator}_${var.stage}"
  }
}

resource "aws_internet_gateway" "internet_gateway_tech_wg" {
  for_each = aws_vpc.vpc_tech_cloud_worshop_g
  vpc_id   = each.value.id
  tags = {
    Name = "vpc_${each.key}_internet_gateway"
  }
}

resource "aws_route_table" "table_public_wg" {
  for_each = aws_vpc.vpc_tech_cloud_worshop_g
  vpc_id   = each.value.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_tech_wg[each.key].id
  }

  route {
    cidr_block = each.value.cidr_block
    gateway_id = "local"
  }

  tags = {
    Name = "rt_public_wg_${each.key}_${var.stage}"
  }
}


resource "aws_route_table" "table_private_wg" {
  for_each = aws_vpc.vpc_tech_cloud_worshop_g
  vpc_id   = each.value.id

  route {
    cidr_block = each.value.cidr_block
    gateway_id = "local"
  }

  tags = {
    Name = "rt_private_wg_${each.key}_${var.stage}"
  }
}

resource "aws_route_table_association" "route_asociationg_public_subnet_1_wg" {
  subnet_id      = aws_subnet.subnets_asociated_wg["cidr_public_a_vpc_1"].id
  route_table_id = aws_route_table.table_public_wg["vpc_1"].id
}

resource "aws_route_table_association" "route_asociationg_public_subnet_2_wg" {
  subnet_id      = aws_subnet.subnets_asociated_wg["cidr_public_b_vpc_1"].id
  route_table_id = aws_route_table.table_public_wg["vpc_1"].id
}

resource "aws_route_table_association" "route_asociationg_public_subnet_3_wg" {
  subnet_id      = aws_subnet.subnets_asociated_wg["cidr_private_a_vpc_1"].id
  route_table_id = aws_route_table.table_private_wg["vpc_1"].id
}

resource "aws_route_table_association" "route_asociationg_public_subnet_4_wg" {
  subnet_id      = aws_subnet.subnets_asociated_wg["cidr_private_b_vpc_1"].id
  route_table_id = aws_route_table.table_private_wg["vpc_1"].id
}


resource "aws_route_table_association" "route_asociationg_public_subnet_1_wg_vpc_2" {
  subnet_id      = aws_subnet.subnets_asociated_wg["cidr_public_a_vpc_2"].id
  route_table_id = aws_route_table.table_public_wg["vpc_2"].id
}

resource "aws_route_table_association" "route_asociationg_public_subnet_2_wg_vpc_2" {
  subnet_id      = aws_subnet.subnets_asociated_wg["cidr_public_b_vpc_2"].id
  route_table_id = aws_route_table.table_public_wg["vpc_2"].id
}

resource "aws_route_table_association" "route_asociationg_public_subnet_3_wg_vpc_2" {
  subnet_id      = aws_subnet.subnets_asociated_wg["cidr_private_a_vpc_2"].id
  route_table_id = aws_route_table.table_private_wg["vpc_2"].id
}

resource "aws_route_table_association" "route_asociationg_public_subnet_4_wg_vpc_2" {
  subnet_id      = aws_subnet.subnets_asociated_wg["cidr_private_b_vpc_2"].id
  route_table_id = aws_route_table.table_private_wg["vpc_2"].id
}


resource "aws_route_table_association" "route_asociationg_public_subnet_1_wg_vpc_3" {
  subnet_id      = aws_subnet.subnets_asociated_wg["cidr_public_a_vpc_3"].id
  route_table_id = aws_route_table.table_public_wg["vpc_3"].id
}

resource "aws_route_table_association" "route_asociationg_public_subnet_2_wg_vpc_3" {
  subnet_id      = aws_subnet.subnets_asociated_wg["cidr_public_b_vpc_3"].id
  route_table_id = aws_route_table.table_public_wg["vpc_3"].id
}

resource "aws_route_table_association" "route_asociationg_public_subnet_3_wg_vpc_3" {
  subnet_id      = aws_subnet.subnets_asociated_wg["cidr_private_a_vpc_3"].id
  route_table_id = aws_route_table.table_private_wg["vpc_3"].id
}

resource "aws_route_table_association" "route_asociationg_public_subnet_4_wg_vpc_3" {
  subnet_id      = aws_subnet.subnets_asociated_wg["cidr_private_b_vpc_3"].id
  route_table_id = aws_route_table.table_private_wg["vpc_3"].id
}