data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_vpc" "vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "${var.instance_name}-vpc"
  }
}

resource "aws_default_route_table" "route_table" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block           = aws_vpc.vpc.cidr_block
    gateway_id           = "local"
  }

  route {
    cidr_block           = "0.0.0.0/0"
    gateway_id           = aws_internet_gateway.gw.id
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.16.10.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.instance_name}-subnet"
  }
}

resource "aws_network_interface" "network_interface" {
  subnet_id   = aws_subnet.subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "${var.instance_name}-nic"
  }
}

resource "aws_security_group" "security_group" {
  name        = "${var.instance_name}-scg"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.instance_name}-scg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "security_group_ingress_rule" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_instance" "vm" {
  ami                    = data.aws_ami.ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.security_group.id]

  tags = {
    Name = var.instance_name
  }
}