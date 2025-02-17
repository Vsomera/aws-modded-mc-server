// policy to grant ec2 access to s3
resource "aws_iam_policy" "s3_access_policy" {
  name        = "mc-s3-bucket-access"
  description = "Allows mc ec2 instance to access S3 bucket"

  policy = file("${path.module}/config/s3_policy.json")
}

// iam role for ec2 instance
resource "aws_iam_role" "mc_ec2_role" {
  name = "mc-ec2-role"

  assume_role_policy = file("${path.module}/config/ec2_role.json")
}

// attaches iam policy to the iam role
resource "aws_iam_role_policy_attachment" "mc_s3_policy_attach" {
  role       = aws_iam_role.mc_ec2_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

// instance profile to attach to ec2 instance
resource "aws_iam_instance_profile" "mc_instance_profile" {
  name = "mc-ec2-instance-profile"
  role = aws_iam_role.mc_ec2_role.name
}
