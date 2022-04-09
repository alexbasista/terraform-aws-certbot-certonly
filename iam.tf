data "aws_s3_bucket" "output_bucket" {
  bucket = var.output_bucket
}

resource "aws_iam_role" "certbotter" {
  name = "certbotter-iam-role"
  tags = merge({
    "Name" = "certbotter-iam-role"
    },
    var.common_tags
  )

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

resource "aws_iam_policy" "certbotter" {
  name = "certbotter-iam-policy"

  tags = merge({
    "Name" = "certbotter-iam-policy"
    },
    var.common_tags
  )

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

resource "aws_iam_policy_attachment" "certbotter" {
  name       = "certbotter-iam-policy-attachment"
  roles      = [aws_iam_role.certbotter.name]
  policy_arn = aws_iam_policy.certbotter.arn
}

resource "aws_iam_instance_profile" "certbotter" {
  name = "certbotter-instance-profile"
  path = "/"
  role = aws_iam_role.certbotter.name

  tags = merge({
    "Name" = "certbotter-instance-profile"
    },
    var.common_tags
  )
}