# Variable
variable "region" {
    default = "ap-southeast-1"
}
variable "availabilityZone" {
    default = "ap-southeast-1a"
  
}
variable "instanceTenancy" {
 default = "default"
}
variable "dnsSupport" {
 default = true
}
variable "dnsHostNames" {
        default = true
}
variable "vpcCIDRblock" {
 default = "10.13.0.0/16"
}
variable "subnetCIDRblock" {
        default = "10.13.0.0/24"
}
variable "destinationCIDRblock" {
        default = "0.0.0.0/0"
}
variable "ingressCIDRblockPublic" {
        type = "list"
        default = [ "0.0.0.0/0" ]        
}
variable "egressCIDRblockPublic" {
        type = "list"
        default = [ "0.0.0.0/0" ]
}        
variable "routeTableCIDRblock" {
  default = "0.0.0.0/0"
}

variable "mapPublicIP" {
        default = true
}

variable "instanceUsername" {
  default = "ubuntu"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "keys/romi-afrizal.pem"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "keys/romi-afrizal.pub"  
}
