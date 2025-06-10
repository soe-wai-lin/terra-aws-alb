variable "aws_profile" {
  type = string
  description = "Check this profile name in ~/.aws/config"
}

variable "aws_region" {
  default = "ap-southeast-1"
  type = string
}
variable "image_id" {
  default = "ami-069cb3204f7a90763"
  description = "Image id of Ubuntu server in ap-southeast-1"
  type = string
}
variable "server_port" {
    description = "The port the server will use for HTTP requests"
    default = 8080
    type = number
}
variable "cluster_name" {
  default = "terra-test"
  description = "The name to use for all the cluster resources"
  type = string
}

variable "db_remote_state_bucket" {
  default = "swlbucket01"
  description = "The name of the S3 bucket for the database's remote state"
  type = string
}
# variable "db_remote_state_key" {
#   description = "The path for the database's remote state in S3"
#   type = string
# }

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g.t2.micro)"
  type = string
  default = "t2.micro"
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type = number
  default = 1
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type = number
  default = 2
}

variable "desired_capacity" {
  description = "The desired number of EC2 Instances in the ASG"
  type = number
  default = 2
}

variable "vpc_name" {
  default = "terra_vpc"
}

variable "vpc_cidr_block" {
  default = "20.0.0.0/16"
  type = string
}

variable "pub_sub_01" {
  default = "20.0.1.0/24"
  type = string
}

variable "pub_sub_02" {
  default = "20.0.2.0/24"
  type = string
}

variable "priv_sub_01" {
  default = "20.0.10.0/24"
  type = string
}

variable "priv_sub_02" {
  default = "20.0.11.0/24"
  type = string
}

variable "data_sub_01" {
  default = "20.0.20.0/24"
  type = string
}

variable "data_sub_02" {
  default = "20.0.21.0/24"
  type = string
}