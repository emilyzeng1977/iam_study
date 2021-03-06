{
  "Comment": "New customer provisioning flow 123",
  "StartAt": "Create customer record",
  "States": {
    "Create customer record": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Parameters": {
        "FunctionName": "arn:aws:lambda:${aws_region}:${account_id}:function:${function_name}",
        "Payload.$": "$"
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException"
          ],
          "IntervalSeconds": 2,
          "MaxAttempts": 6,
          "BackoffRate": 2
        }
      ],
      "Next": "CreateUserPool",
      "ResultSelector": {
        "customer": {
          "id.$": "$.Payload.id",
          "name.$": "$.Payload.name"
        }
      }
    },
    "CreateUserPool": {
      "Type": "Task",
      "Parameters": {
        "PoolName.$": "$.customer.name"
      },
      "Resource": "arn:aws:states:::aws-sdk:cognitoidentityprovider:createUserPool",
      "ResultPath": "$.UserPool",
      "ResultSelector": {
        "Id.$": "$.UserPool.Id"
      },
      "Next": "CreateUserPoolClient"
    },
    "CreateUserPoolClient": {
      "Type": "Task",
      "Parameters": {
        "ClientName.$": "$.customer.name",
        "UserPoolId.$": "$.UserPool.Id",
        "AllowedOAuthFlows": [
          "implicit"
        ],
        "AllowedOAuthScopes": [
          "openid",
          "profile"
        ],
        "SupportedIdentityProviders": [
          "COGNITO"
        ],
        "CallbackURLs": [
          "https://example.com"
        ],
        "AllowedOAuthFlowsUserPoolClient": true
      },
      "Resource": "arn:aws:states:::aws-sdk:cognitoidentityprovider:createUserPoolClient",
      "Next": "CreateUserPoolDomain",
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "Next": "DeleteUserPool"
        }
      ],
      "ResultPath": "$.UserPoolClient",
      "ResultSelector": {
        "ClientId.$": "$.UserPoolClient.ClientId"
      }
    },
    "CreateUserPoolDomain": {
      "Type": "Task",
      "End": true,
      "Parameters": {
        "Domain.$": "$.customer.id",
        "UserPoolId.$": "$.UserPool.Id"
      },
      "Resource": "arn:aws:states:::aws-sdk:cognitoidentityprovider:createUserPoolDomain",
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "Next": "DeleteUserPoolClient"
        }
      ],
      "ResultPath": "$.UserPoolDomain"
    },
    "DeleteUserPoolClient": {
      "Type": "Task",
      "Parameters": {
        "ClientId.$": "$.UserPoolClient.Id",
        "UserPoolId.$": "$.UserPool.Id"
      },
      "Resource": "arn:aws:states:::aws-sdk:cognitoidentityprovider:deleteUserPoolClient",
      "Next": "DeleteUserPool"
    },
    "DeleteUserPool": {
      "Type": "Task",
      "End": true,
      "Parameters": {
        "UserPoolId.$": "$.UserPool.Id"
      },
      "Resource": "arn:aws:states:::aws-sdk:cognitoidentityprovider:deleteUserPool"
    }
  }
}
