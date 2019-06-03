# aws-cloudformation-user-pool-client-secret-provider-lambda

## Purpose

When you provision a Cognito user pool app client (AWS::Cognito::UserPoolClient) with CloudFormation, you may want to programmatically share the app client's secret in an easily-referencable way to other users or resources. For example, you may want to pass the app client secret to a Lambda function or expose it as a CloudFormation template output for manual retrieval or programmatic access. 

However, since the value is a secret, we do not want to directly expose it. Rather, this project provides a custom CloudFormation resource (i.e. a Lambda function) that takes a Cognito User Pool ID and Cognito User Pool Client App ID as input, retrieves the corresponding app client secret, stores it in an AWS Secrets Manager secret, and returns the secret's name, ARN, and console URL. 

With this approach, the secret itself is not exposed; we only share the Secrets Manager secret name (and ARN). The secret value may only be retrieved by those IAM principles that have secretsmanager:GetSecret permissions to the Secrets Manager resource itself. 

## Resources Created

If you deploy the example template, the following resources will be created:

1. Cognito user pool
2. Cognito user pool application client
3. Lambda function
4. IAM role for the Lambda function
5. Custom::UserPoolClientSecret, which is actually backed by a secret in AWS Secrets Manager

Except for the AWS Secrets Manager Secret which has a cost of ~$1/month, these resources are generally charged only upon usage (API calls, etc.) and thus nearly free for brief demo purposes. Expected charges are < $1 (possibly nearly free, depending on whether Secrets Manager pro-rates for secrets that existed only partially during a month). 

## Usage

1. Edit **deploy.sh** and set the BUCKET variable to the name of an S3 bucket to use for storing later CloudFormation templates. 

    ```sh
    # deploy.sh
    BUCKET=your_bucket_name
    ```

2. Build and deploy the CloudFormation template by running deploy.sh from the project root:

    ```sh
    $ ./deploy.sh
    ```

3. After the CloudFormation template completes, open the CloudFormation Console, click the **cognito-app-client-secret-provider-demo** stack, and view the **Outputs**:

    ![cloudformation-outputs]

4. Click the link for the **UserPoolAppClientSecretLink** output to be taken to corresponding secret in AWS Secrets Manager.

    Scroll down to the **Secret value** section and click **Retrieve secret value**:

    ![retrieve-secret]

    The secret contains a key-value map of Cognito user pool ID, app ID, and app secret: 

    ![secret-value]

[cloudformation-outputs]: ./images/cloudformation-outputs.png
[retrieve-secret]: ./images/retrieve-secret.png
[secret-value]: ./images/secret-value.png

5. You can programmatically obtain the app client secret by making a GetSecret() API call from the AWS SDKs or CLI. You can obtain the secret name needed in the API call from the CloudFormation stack's output values. 