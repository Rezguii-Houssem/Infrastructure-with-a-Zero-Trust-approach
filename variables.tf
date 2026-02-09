variable "env_config" {
    type = map(object({
        region              = string
        vpc_cidr            = string
        project_name        = string
        private_subnet_cidr = list(string)
        availability_zones  = list(string)
    }))
    default = {
      "dev" = {
        region              = "eu-west-3"
        project_name        = "Dev-Alpha-Project"
        private_subnet_cidr = ["10.0.1.0/24"]
        availability_zones  = ["eu-west-3a"]
        vpc_cidr            = "10.0.0.0/16"
      }
      "prod" = {
        region              = "eu-central-1"
        project_name        = "Alpha-Project"
        private_subnet_cidr = ["172.16.1.0/24"]
        availability_zones  = ["eu-central-1a"]
        vpc_cidr            = "172.16.0.0/16"
      }
    }
}


