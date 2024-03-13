variable "vpccidr" {
  type        = string
  description = "VPC CIDR"
  default     = "10.0.0.0/16"

}

variable "commontags" {
  type = map(string)

  default = {
    Project_Name = "TestProject"
    Env          = "TestEnv"

  }
}

variable "publicsubnetscidr" {
  type        = list(string)
  description = "Publicsubnetcidr"
  default     = ["10.0.0.0/20", "10.0.16.0/20"]

}

variable "privatesubnetscidr" {
  type        = list(string)
  description = "Privatesubnetcidr"
  default     = ["10.0.32.0/20", "10.0.48.0/20"]

}

variable "route1" {
  type        = string
  description = "publiccrt"
  default     = "0.0.0.0/0"

}

variable "route2" {
  type        = string
  description = "privatecrt"
  default     = "0.0.0.0/0"

}

variable "az" {
  type        = list(string)
  description = "az"
  default     = ["us-east-1a", "us-east-1b"]

}

  