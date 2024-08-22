# TODO: Designate a cloud provider, region, and credentials
# Input correct credentials account login by aws cli
provider "aws" {
key_sample_1 = "..."
key_sample_2 = "..."
region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "172.31.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.31.16.0/20"

  tags = {
    Name = "Main"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
name = "iam_for_lambda"
assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
{
"Action": "sts:AssumeRole",
"Principal": {
"Service": "lambda.amazonaws.com"
},
"Effect": "Allow",
"Sid": ""
}
]
}
EOF
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
name = "/aws/lambda/${var.lambda_name}"
retention_in_days = 14
}

resource "aws_iam_policy" "lambda_logs_policy" {
name = "lambda_logs_policy"
path = "/"
policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
{
"Action": [
"logs:CreateLogGroup",
"logs:CreateLogStream",
"logs:PutLogEvents"
],
"Resource": "arn:aws:logs:*:*:*",
"Effect": "Allow"
}
]
}
EOF
}

#Assign policy to the role
resource "aws_iam_role_policy_attachment" "lambda_logs_policy" {
role = aws_iam_role.iam_for_lambda.name
policy_arn = aws_iam_policy.lambda_logs_policy.arn
}

resource "aws_lambda_function" "lambda" {
function_name = var.lambda_name
filename = var.lambda_source_path
source_code_hash = filebase64sha256(var.lambda_source_path)
handler = "lambda.lambda_handler"
runtime = "python3.8"
role = aws_iam_role.iam_for_lambda.arn
environment{
variables = {
greeting = "Hello Udacity!"
}
}

depends_on = [aws_iam_role_policy_attachment.lambda_logs_policy, aws_cloudwatch_log_group.lambda_log_group]
}