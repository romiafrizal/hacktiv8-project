resource "aws_elb" "hacktiv8-project-elb" {
  name = "hacktiv8-project-elb"
  subnets = ["${aws_subnet.hacktiv8-project-subnet.id}"]
  security_groups = ["${aws_security_group.hacktiv8-elb-sg.id}"]

listener {
  instance_port = 80
  instance_protocol = "http"
  lb_port = 80
  lb_protocol = "http"  
}

health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "http:80/"
    interval = 30
}

instances = ["${aws_instance.wordpress.*.id}"]
cross_zone_load_balancing = true
connection_draining = true
connection_draining_timeout = 400
tags {
    Name = "hacktiv8-project-elb"
  }
}
