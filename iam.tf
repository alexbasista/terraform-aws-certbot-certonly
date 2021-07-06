data "aws_s3_bucket" "output_bucket" {
  bucket = var.output_bucket
}

resource "aws_iam_role" "ubuntu_certbot" {
  name = "ubuntu-certbot-iam-role"
  tags = { Name = "ubuntu-certbot-iam-role" }

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
POLICY
}

resource "aws_iam_policy" "ubuntu_certbot" {
  name = "ubuntu-certbot-iam-policy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "UploadToS3",
      "Effect": "Allow",
      "Action": "*",
      "Resource": [
        "${data.aws_s3_bucket.output_bucket.arn}",
        "${data.aws_s3_bucket.output_bucket.arn}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "ubuntu_certbot" {
  name = "ubuntu-certbot-iam-policy-attachment"
  roles      = [aws_iam_role.ubuntu_certbot.name]
  policy_arn = aws_iam_policy.ubuntu_certbot.arn
}

resource "aws_iam_instance_profile" "ubuntu_certbot" {
  name = "ubuntu-certbot-instance-profile"
  path = "/"
  role = aws_iam_role.ubuntu_certbot.name
}