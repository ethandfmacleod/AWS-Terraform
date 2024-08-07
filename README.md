# AWS-Terraform
A Terraform project for managing the infrastructure of the "BetterReads" application

## Table of Contents

- [Installation](#installation)
  - [Terraform](#install-terraform)
  - [AWS CLI](#install-aws-cli)
- [Configuration](#configuration)
  - [AWS Credentials](#aws-credentials)
  - [Terraform Variables](#terraform-variables)
- [Usage](#usage)
  - [Initialize Terraform](#initialize-terraform)
  - [Plan the Infrastructure](#plan-the-infrastructure)
  - [Apply the Configuration](#apply-the-configuration)
  - [Destroy the Infrastructure](#destroy-the-infrastructure)

## Installation

### Install Terraform
- Go to the [Terraform download page](https://www.terraform.io/downloads.html).
- Download the appropriate package for your operating system.
- Add Terraform to envrionment variables
- A detailed guide can be found at the [Terraform Website](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Install AWS CLI
   - Follow the instructions on the [AWS CLI installation page](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).

## Configuration

### AWS Credentials

To use Terraform with AWS, you need to configure your AWS credentials. You can do this by using the `aws configure` command.
You will be prompted to enter your AWS Access Key ID, Secret Access Key, region, and output format.

Alternatively, you can set the credentials in the ~/.aws/credentials file:
```
[default]
aws_access_key_id = YOUR_ACCESS_KEY_ID
aws_secret_access_key = YOUR_SECRET_ACCESS_KEY
```

### Terraform Variables
Some user defined fields are required to run this program. Create a file called `terraform.tfvars` in the root directory and add the following values:

```
region         = "us-west-2"      // Your region
user           = "Terraform User" // Name of the previously created credentials
instance_type  = "t2.micro"
ami_id         = "ami-12345678"
key_name       = "your-key-pair" // Generated Key-Value pair
```

## Usage
### Initialize Terraform
Before using Terraform, you need to initialize the working directory. This command downloads the necessary provider plugins.
```
terraform init
```
### Plan the Infrastructure
The terraform plan command creates an execution plan, which shows you what actions Terraform will take to reach the desired state defined in the configuration files.
```
terraform plan
```
### Apply the Configuration
The terraform apply command executes the actions proposed in the execution plan to reach the desired state of the configuration.
```
terraform apply
```
### Destroy the Infrastructure
If you need to tear down the infrastructure managed by Terraform, you can use the terraform destroy command. This command will destroy all resources defined in your Terraform configuration.
```
terraform destroy
```