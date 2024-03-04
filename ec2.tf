data "aws_ami" "ubuntu" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
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
  count = var.ec2_subnet_id == null ? 0 : 1

  id = var.ec2_subnet_id
}

locals {
  user_data_args = {
    cert_fqdn     = var.cert_fqdn
    cert_email    = var.cert_email
    output_bucket = var.s3_output_bucket
  }
}

resource "aws_instance" "certbotter" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.ec2_instance_type
  subnet_id                   = var.ec2_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.certbotter.id]
  key_name                    = var.ec2_ssh_key_pair
  user_data                   = templatefile("${path.module}/templates/user_data.sh.tpl", local.user_data_args)
  iam_instance_profile        = aws_iam_instance_profile.certbotter.name

  root_block_device {
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "gp2"
  }

  tags = merge({
    "Name" = "certbotter-ec2"
    },
    var.common_tags
  )
}

resource "aws_security_group" "certbotter" {
  name   = "certbotter-sg-allow"
  vpc_id = var.ec2_subnet_id == null ? null : data.aws_subnet.subnet[0].vpc_id

  tags = merge({
    "Name" = "certbotter-sg-allow"
    },
    var.common_tags
  )
}

resource "aws_security_group_rule" "ssh" {
  count = length(var.cidr_ingress_ssh_allow) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.cidr_ingress_ssh_allow
  security_group_id = aws_security_group.certbotter.id
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.certbotter.id
}

resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.certbotter.id
}