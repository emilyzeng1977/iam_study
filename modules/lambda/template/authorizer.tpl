{
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:CreateLogGroup",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:logs:${aws_region}:${account_id}:log-group:/aws/lambda/${function_name}:*:*"
    },
    {
      "Action": [
        "ssm:GetParameters"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:ssm:${aws_region}:${account_id}:parameter/${stage}/*"
    },
    {
      "Action": [
        "xray:PutTraceSegments",
        "xray:PutTelemetryRecords"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": ["ec2:DescribeInstances"],
      "Resource": "*"
    }
  ],
  "Version": "2012-10-17"
}
