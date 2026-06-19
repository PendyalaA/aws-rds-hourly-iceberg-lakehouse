data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"

  selected_azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${local.name_prefix}-vpc"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${local.name_prefix}-igw"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = local.selected_azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${local.name_prefix}-public-subnet-${count.index + 1}"
    Project     = var.project_name
    Environment = var.environment
    Tier        = "public"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = local.selected_azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${local.name_prefix}-private-subnet-${count.index + 1}"
    Project     = var.project_name
    Environment = var.environment
    Tier        = "private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${local.name_prefix}-public-rt"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count = length(aws_subnet.private)

  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${local.name_prefix}-private-rt-${count.index + 1}"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_security_group" "compute" {
  name        = "${local.name_prefix}-compute-sg"
  description = "Security group for Lambda and Glue jobs"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "${local.name_prefix}-compute-sg"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_security_group" "rds" {
  name        = "${local.name_prefix}-rds-sg"
  description = "Security group for private RDS PostgreSQL"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "${local.name_prefix}-rds-sg"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_egress_rule" "compute_to_rds_postgres" {
  security_group_id            = aws_security_group.compute.id
  referenced_security_group_id = aws_security_group.rds.id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
  description                  = "Allow compute services to connect to RDS PostgreSQL"
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_compute_postgres" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.compute.id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
  description                  = "Allow PostgreSQL traffic from compute security group"
}