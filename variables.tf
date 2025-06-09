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
  default = 2
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type = number
  default = 2
}