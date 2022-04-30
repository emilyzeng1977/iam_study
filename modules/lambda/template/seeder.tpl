{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:CreateLogStream",
                "logs:CreateLogGroup",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${aws_region}:${account_id}:log-group:/aws/lambda/${service}-${stage}-${handler}:*:*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "ssm:GetParameters"
            ],
            "Resource": "arn:aws:ssm:${aws_region}:${account_id}:parameter/${stage}/*",
            "Effect": "Allow"
        }
    ]
}
