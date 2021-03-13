# lugchat
IM webapp using AWS serverless resources

**WARNING**: This app makes a lot of API requests in the background. AWS provides one million free requests a month,
but if you leave this app running in a tab for ~30 minutes, it may chew through them. Don't leave it running when you're
not using it.

## Requirements
* Terraform
* An AWS account and the AWS CLI
  * All of the necessary resources can be used with the free tier
  * [Setup your credentials locally first](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
* npm

## Backend setup

1. cd to backend/
2. Package the code for the Lambdas with the included script: `./package-lambdas.sh`
3. Download the AWS provider with `terraform init`
4. Create the infrastructure with `terraform apply`. Type "yes" when prompted.

## Frontend setup

1. Get some necessary info with `terraform show`
* Under aws_api_gateway_stage.lugchat, find the invoke_url
* Under aws_s3_bucket.lugchat, find the id and website_endpoint
2. cd to frontend
3. Download modules with `npm install`
4. In src/App.js, enter your API stage's invoke URL on line 10
5. Create the static files with `npm run build`
6. Upload the files to S3 with `aws s3 sync build/ s3://<bucket id from step 1> --acl public-read`

## Use

1. Navigate to the website endpoint you found in step 1 of frontend setup

## Cleanup

1. Remove all bucket files with `aws s3 rm --recursive s3://<bucket id>`
2. cd to backend/
3. Destroy resources with `terraform destroy` 
