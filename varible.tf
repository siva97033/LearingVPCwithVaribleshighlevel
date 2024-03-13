variable "region" {
  type    = string
  default = "us-east-1"

}

variable "vpccidr" {
  type    = string
  default = "10.0.0.0/16"

}

variable "commontags" {
  type = map(string)
  default = {
    "env"         = "prod"
    "owner"       = "siva"
    "Projectname" = "testvpc"


  }

}

variable "publicsubnetcidr" {
  type    = list(string)
  default = ["10.0.0.0/20", "10.0.16.0/20"]

}

variable "privatesubnetcidr" {
  type    = list(string)
  default = ["10.0.32.0/19" , "10.0.64.0/19"]

}

variable "route1" {
  type        = string
  description = "publicroutecidr"
  default     = "0.0.0.0/0"

}

variable "route2" {
  type        = string
  description = "privateroutecidr"
  default     = "0.0.0.0/0"
}

variable "az" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]

}