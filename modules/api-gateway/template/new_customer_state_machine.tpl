#set( $body = $util.escapeJavaScript($input.json('$')).replaceAll("\\'", "'") )
{
  "input": "$body",
  "name": "$context.requestId",
  "stateMachineArn":"${new_customer_state_machine_arn}"
}
