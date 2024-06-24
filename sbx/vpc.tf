/*resource "aws_vpc" "vpc_tech_cloud" {
  cidr_block           = var.cidrs_available_vpce["cidr_vpce"]
  enable_dns_support   = true
  enable_dns_hostnames = true #gives you an internal host name
  instance_tenancy     = "default"
  tags = {
    Name = "vpc_tech_cloud"
  }

}

# Create four subnets 
resource "aws_subnet" "subnets_asociated" {
  for_each                = var.cidrs_available_subnet
  vpc_id                  = aws_vpc.vpc_tech_cloud.id
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = strcontains(each.key, "public") ? true : false
  availability_zone       = each.value.zona_valida
  tags = {
    Name = "vpc_tech_cloud-${each.key}"
  }
}

resource "aws_internet_gateway" "internet_gateway_tech" {
  vpc_id = aws_vpc.vpc_tech_cloud.id
  tags = {
    Name = "vpc_tech_cloud_internet_gateway"
  }
}

resource "aws_route_table" "table_public" {
  vpc_id = aws_vpc.vpc_tech_cloud.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_tech.id
  }

  route {
    cidr_block = aws_vpc.vpc_tech_cloud.cidr_block
    gateway_id = "local"
  }

  tags = {
    Name = "rt_public"
  }
}


resource "aws_route_table" "table_private" {
  vpc_id = aws_vpc.vpc_tech_cloud.id



  route {
    cidr_block = aws_vpc.vpc_tech_cloud.cidr_block
    gateway_id = "local"
  }

  tags = {
    Name = "rt_private"
  }
}

resource "aws_route_table_association" "route_asociationg_public_subnet_1" {
  subnet_id      = aws_subnet.subnets_asociated["cidr_public_a"].id
  route_table_id = aws_route_table.table_public.id
}

resource "aws_route_table_association" "route_asociationg_public_subnet_2" {
  subnet_id      = aws_subnet.subnets_asociated["cidr_public_b"].id
  route_table_id = aws_route_table.table_public.id
}

resource "aws_route_table_association" "route_asociationg_private_subnet_1" {
  subnet_id      = aws_subnet.subnets_asociated["cidr_private_a"].id
  route_table_id = aws_route_table.table_private.id
}

resource "aws_route_table_association" "route_asociationg_private_subnet_2" {
  subnet_id      = aws_subnet.subnets_asociated["cidr_private_b"].id
  route_table_id = aws_route_table.table_private.id
} */