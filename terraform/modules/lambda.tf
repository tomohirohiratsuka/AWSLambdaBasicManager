#####################################################
## Lambda Archive File
#####################################################
resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.lambda_source_dir
  output_path = "${path.module}/lambda_function_${random_string.random.result}.zip"
}



#####################################################
## Lambda Deployment
#####################################################
resource "aws_lambda_function" "main" {
  function_name    = var.lambda_function_name
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  role             = aws_iam_role.lambda_exec.arn
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)
}
#####################################################
## Lambda permission to allow ALB to invoke Lambda
#####################################################

resource "aws_lambda_permission" "alb" {
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.lambda.arn
}
