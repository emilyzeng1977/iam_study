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
                "cognito-idp:ListUserPools"
            ],
            "Resource": [
                "*"
            ],
            "Effect": "Allow"
        }
    ]
}
