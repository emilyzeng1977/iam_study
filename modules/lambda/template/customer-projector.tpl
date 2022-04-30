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
                "arn:aws:logs:${aws_region}:${account_id}:log-group:/aws/lambda/iam-${stage}-${handler}:*:*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "kinesis:GetRecords",
                "kinesis:GetShardIterator",
                "kinesis:DescribeStream",
                "kinesis:ListStreams"
            ],
            "Resource": [
                "arn:aws:kinesis:${aws_region}:${account_id}:stream/kinesis_demo"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "ssm:GetParameters"
            ],
            "Resource": "arn:aws:ssm:${aws_region}:${account_id}:parameter/${stage}/*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": "arn:aws:kms:${aws_region}:${account_id}:key/f82bfa78-ab66-47ef-ab2c-3bc53142f758",
            "Effect": "Allow"
        }
    ]
}
