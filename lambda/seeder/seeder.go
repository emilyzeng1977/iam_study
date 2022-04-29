// Lambda lambda which gets an Overlay request JWT and
// Convert it into an IAM policy with matching customer ID
//
// The plan is for this lambda to be generalized and possibly reused
// as lambda for other lambdas
package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/lambda"
)

type SampleEvent struct {
	ID   string `json:"id123"`
	Val  int    `json:"val"`
	Flag bool   `json:"flag"`
}

func HandleRequest(ctx context.Context, event SampleEvent) (string, error) {
	return fmt.Sprintf("%+v", event), nil
}

func main() {
	lambda.Start(HandleRequest)
}
