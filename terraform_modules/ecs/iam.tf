resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
 
resource "aws_iam_policy" "ecs_task_policy" {
  name        = "ecs_task_policy"
  description = "Policy that allows access to ECR"
 
 policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": ["ecr:*"],
           "Resource": "*"
       }
   ]
}
EOF
}
 
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_policy.arn
}