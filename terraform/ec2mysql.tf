resource "aws_instance" "mysql" {
  ami   = "ami-08050c889a630f1bd" 
  instance_type = "t2.micro"
  count = 1
  associate_public_ip_address = "${var.mapPublicIP}"
  availability_zone = "${var.availabilityZone}"
  key_name = "${aws_key_pair.romikey-tf.key_name}"

  subnet_id = "${aws_subnet.hacktiv8-project-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.hacktiv8-project-sg.id}"]

  provisioner "file" {
    source = "etc/ec2mysql.sh"
    destination = "/tmp/ec2mysql.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/ec2mysql.sh",
      "sudo /tmp/ec2mysql.sh"
    ]
  }

  connection {
    user = "${var.instanceUsername}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }
  tags = {
    Name= "hactiv8-project-MYSQL"
    }
}