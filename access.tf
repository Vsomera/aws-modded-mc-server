resource "aws_iam_policy" "s3_access_policy" {
  name        = "mc-s3-bucket-access"
  description = "Allows mc ec2 instance to access S3 bucket"

  policy = file("${path.module}/config/s3_policy.json")
}

