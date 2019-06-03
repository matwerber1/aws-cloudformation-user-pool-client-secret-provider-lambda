# MODIFY THIS LINE:
BUCKET=Your_bucket_name

# DO NOT MODIFY
#-------------------------------------------------
STACK_NAME=cognito-app-client-secret-provider-demo

sam package \
    --s3-bucket $BUCKET \
    --template-file template.yaml \
    --output-template-file packaged.yaml

sam deploy \
    --template-file packaged.yaml \
    --stack-name $STACK_NAME \
    --capabilities CAPABILITY_IAM
