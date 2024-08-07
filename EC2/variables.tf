variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to use"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The ID of the AMI to use for the instance"
  type        = string
  default     = "ami-02346a771f34de8ac"
}