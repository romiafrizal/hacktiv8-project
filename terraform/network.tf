resource "aws_vpc" "hacktiv8-project-vpc" {
  cidr_block            = "${var.vpcCIDRblock}"
  instance_tenancy      = "${var.instanceTenancy}"
  enable_dns_hostnames  = "${var.dnsHostNames}"
  enable_dns_support    = "${var.dnsSupport}"
tags {
  Name = "hacktiv8-project-vpc"
  }
}

# CREATE SUBNET
resource "aws_subnet" "hacktiv8-project-subnet" {
  vpc_id                  = "${aws_vpc.hacktiv8-project-vpc.id}"
  cidr_block              = "${var.subnetCIDRblock}"
  map_public_ip_on_launch = "${var.mapPublicIP}"
  availability_zone       = "${var.availabilityZone}"
tags {
  Name = "hacktiv8-project-subnet"
 }
}


#CREATE INTERNET GATEWAY
resource "aws_internet_gateway" "hacktiv8-project-internetGateway" {
  vpc_id = "${aws_vpc.hacktiv8-project-vpc.id}"
tags {
  Name = "hacktiv8-project-internetGateway"
 }
}

#CREATE ROUTE TABLE
resource "aws_route_table" "hacktiv8-project-routeTable" {
  vpc_id = "${aws_vpc.hacktiv8-project-vpc.id}"
  route {
    cidr_block = "${var.routeTableCIDRblock}"
    gateway_id = "${aws_internet_gateway.hacktiv8-project-internetGateway.id}"
  }
tags {
  Name = "hacktiv8-project-routeTable"
 }
}

#ROUTE TABLE ASSOCIATE W/ SUBNET
resource "aws_route_table_association" "hacktiv8-project-association" {
  subnet_id = "${aws_subnet.hacktiv8-project-subnet.id}"
  route_table_id = "${aws_route_table.hacktiv8-project-routeTable.id}"
}

# SECURITY GROUP (INSTANCES)
resource "aws_security_group" "hacktiv8-project-sg" {
  vpc_id = "${aws_vpc.hacktiv8-project-vpc.id}"
  name = "hacktiv8-project-sg"
  description = "security group hactiv8 instance"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = "${var.egressCIDRblockPublic}"
  } 

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = "${var.ingressCIDRblockPublic}"
  }
 
ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = "${var.ingressCIDRblockPublic}"
  }

ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = "${var.ingressCIDRblockPublic}"
  }
}

#Security Group (ELB)
resource "aws_security_group" "hacktiv8-elb-sg" {
  vpc_id = "${aws_vpc.hacktiv8-project-vpc.id}"
  name = "hactiv8-elb-sg"
  description = "SG for Hacktiv8 load balancer"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.egressCIDRblockPublic}"]
  }  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${var.ingressCIDRblockPublic}"]
  }
  tags {
    name = "hacktiv8-project-elb"
  }
}
