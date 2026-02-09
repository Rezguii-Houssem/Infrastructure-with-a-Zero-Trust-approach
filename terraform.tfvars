
env_config = {
    "dev" = {
        region              = "eu-west-3"
        project_name        = "THE_ALPHA_PROJECT"
        vpc_cidr            = "10.0.0.0/16"
        private_subnet_cidr = ["10.0.1.0/24"]
        ami_id              = "ami-00634bca710e8ccb1"
        availability_zones  = ["eu-west-3a"]
  }
    "prod" = {
        region              = "eu-central-1"
        project_name        = "THE_ALPHA_PROJECT_PROD"
        vpc_cidr            = "172.16.0.0/16"
        private_subnet_cidr = ["172.16.1.0/24"]
        ami_id              = "ami-00634b540718e8ccb1"
        availability_zones  = ["eu-central-1a"]
}
}