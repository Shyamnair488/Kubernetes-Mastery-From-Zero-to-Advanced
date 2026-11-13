variable "region" {
  type    = string
  default = "ap-south-1"
}
variable "cluster_name" {
  type    = string
  default = "k8s-lab"
}
variable "cluster_version" {
  type    = string
  default = "1.31"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}
variable "node_min" {
  type    = number
  default = 2
}
variable "node_max" {
  type    = number
  default = 4
}
variable "node_desired" {
  type    = number
  default = 2
}
