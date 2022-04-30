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
                "kms:Decrypt"
            ],
            "Resource": "arn:aws:kms:${aws_region}:${account_id}:key/${kms_key_val}",
            "Effect": "Allow"
        },
        {
            "Action": [
                "dynamodb:Query",
                "dynamodb:PutItem"
            ],
            "Resource": "arn:aws:dynamodb:${${aws_region}}:${account_id}:table/events",
            "Effect": "Allow"
        }
    ]
}
