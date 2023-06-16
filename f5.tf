resource "aws_network_interface" "mgmt" {
  subnet_id       = module.vpc.public_subnets[0]
  private_ips     = ["10.0.1.10"]
  security_groups = [aws_security_group.mgmt.id]
}

resource "aws_network_interface" "public" {
  subnet_id       = module.vpc.public_subnets[1]
  private_ips     = ["10.0.2.10", "10.0.2.101"]
  security_groups = [aws_security_group.public.id]
}

resource "aws_network_interface" "private" {
  subnet_id       = module.vpc.private_subnets[0]
  private_ips     = ["10.0.3.10"]
  security_groups = [aws_security_group.public.id]
}

resource "aws_eip" "mgmt" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.mgmt.id
  associate_with_private_ip = "10.0.1.10"
}
resource "aws_eip" "self" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.public.id
  associate_with_private_ip = "10.0.2.10"
}

resource "aws_eip" "vs" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.public.id
  associate_with_private_ip = "10.0.2.101"
}

data "aws_ami" "f5_ami" {
  most_recent = true
  #name_regex       = "*BIGIP-16.1.*PAYG-Best*25Mbps*"
  owners = ["679593333241"]

  filter {
    name   = "name"
    values = ["*BIGIP-16.1.*PAYG-Best*25Mbps*"]
  }
}

resource "random_string" "password" {
  length  = 10
  special = false
}
resource "aws_instance" "f5_instance" {
  ami           = data.aws_ami.f5_ami.id
  instance_type = "t3.medium"
  key_name      = aws_key_pair.demo.key_name

  network_interface {
    network_interface_id = aws_network_interface.mgmt.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.public.id
    device_index         = 1
  }

  network_interface {
    network_interface_id = aws_network_interface.private.id
    device_index         = 2
  }

  tags = {
    Name = "F5 201 Terraform Workshop"
  }
}


