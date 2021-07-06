# data "aws_ami" "ubuntu" {
#   owners      = ["099720109477"]
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   filter {
#     name   = "state"
#     values = ["available"]
#   }
# }

data "aws_ami" "ubuntu" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_subnet" "subnet" {
  id = var.subnet_id
}

locals {
  user_data_args = {
    cert_fqdn     = var.cert_fqdn
    cert_email    = var.cert_email
    output_bucket = var.output_bucket
  }
}

resource "aws_instance" "ubuntu_certbot" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ubuntu_certbot.id]
  key_name                    = var.ssh_key_pair
  user_data                   = templatefile("${path.module}/templates/user_data.sh.tpl", local.user_data_args)
  iam_instance_profile        = aws_iam_instance_profile.ubuntu_certbot.name

  root_block_device {
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "gp2"
  }

  tags = {
    Name = "ubuntu-certbot-ec2"
  }
}

resource "aws_security_group" "ubuntu_certbot" {
  name   = "ubuntu-certbot-allow"
  vpc_id = data.aws_subnet.subnet.vpc_id
}

resource "aws_security_group_rule" "ssh" {
  count = length(var.cidr_ingress_ssh_allow) > 0 ? 1 : 0
  
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.cidr_ingress_ssh_allow
  security_group_id = aws_security_group.ubuntu_certbot.id
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ubuntu_certbot.id
}

resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ubuntu_certbot.id
}