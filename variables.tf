
variable "name" {
  description = "The name for the resource"
  default = "example"
}
variable "environment" {
  description = "The env of the app"
  default = "staging"
}
variable "subnets" {
  description = "Its a list of subnets ids"
  default = [ "SUBNET_ID" ]
  type = "list"
}
variable "vpc_id" {
  description = "ID of VPC being used"
  default = "VPC_ID"
}
