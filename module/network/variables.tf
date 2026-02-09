variable "vpc_cidr" {
    description = "The cidr block of the vpc"
    type = string
  
}


variable "private_subnet_cidr" {
    description = "the cidr blocks of the private subnets"
    type = list(string)
}


variable "availability_zones" {
    description = "the availability zones"
    type = list(string)

}


variable "region" {
    description = "the region"
    type = string

}
variable "project_name" {
    description = "the name of the project"
    type = string    
  
}