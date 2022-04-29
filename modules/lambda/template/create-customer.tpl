{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:CreateLogStream",
                "logs:CreateLogGroup"
            ],
            "Resource": [
                "arn:aws:logs:${aws_region}:${account_id}:log-group:/aws/lambda/${service}-${stage}*:*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${aws_region}:${account_id}:log-group:/aws/lambda/${service}-${stage}*:*:*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": "${kms_key}",
            "Effect": "Allow"
        },
        {
            "Action": [
                "dynamodb:Query",
                "dynamodb:PutItem"
            ],
            "Resource": "arn:aws:dynamodb:${aws_region}:${account_id}:table/events",
            "Effect": "Allow"
        }
    ]
}
