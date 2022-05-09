This infrastructure was developed and designed in mind for use with the alcoudguru AWS sandbox account. As a result certain steps are needed to be taken to provision the required resources. These are detailed in setup below.

The design intent was to build a scalable, modern and maintainable microservice backend for the [Get Scheduled App](https://github.com/mjki4hj3/get-scheduled). 

## Prerequisites 

- Authenticated via [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Installed [Terraform CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Installed [Docker](https://docs.docker.com/get-docker/)

## Setup Instructions

Authenticate with AWS CLI via 

```bash
aws configure 
```

### Terraform
To provision the infrastructure in AWS after authenticating via the cli runng the follwoing commands.

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Once infrastructure is provisioned you will notice that the ECS task will be stuck on pending. This is because it is trying to pull an image from ECR that does not exist!

To fix this lets create a docker image and push the image it ECR.

```bash
cd ../docker

$(aws ecr get-login --no-include-email) #Log into ECR

docker build . -t $REPLACE_WITH_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/getscheduled/service:latest

docker push $REPLACE_WITH_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/getscheduled/service:latest

aws ecr describe-images --repository-name getscheduled/service # Check image is available on ecr
```

Once ECS task is running then enter the NLB URL to the backend up and running!
 

## Improvements

- Docker security best practices need to be implemented
- Implement developer
- Use ALB instead of NLB
- Once ALB is in place use that instead of NAT Gateways
- Update high level architechture diagram to only show on AZ to declutter diagram
