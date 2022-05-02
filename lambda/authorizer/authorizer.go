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
	ID   string `json:"id"`
	Val  int    `json:"val"`
	Flag bool   `json:"flag"`
}

func HandleRequest(ctx context.Context, event SampleEvent) (string, error) {
	// Load session from shared config
	//sess := session.Must(session.NewSessionWithOptions(session.Options{
	//    SharedConfigState: session.SharedConfigEnable,
	//}))
	//
	//// Create new EC2 client
	//ec2Svc := ec2.New(sess)
	//
	//// Call to get detailed information on each instance
	//result, err := ec2Svc.DescribeInstances(nil)
	//if err != nil {
	//    fmt.Println("EC2 Error", err)
	//} else {
	//    fmt.Println("EC2 Success", result)
	//}
	fmt.Println("Lambda Success")

	return fmt.Sprintf("%+v", event), nil
}

func main() {
	lambda.Start(HandleRequest)
}
