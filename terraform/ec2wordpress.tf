resource "aws_instance" "wordpress" {
  ami   = "ami-08050c889a630f1bd"
  instance_type = "t2.micro"
  count = 2 
  associate_public_ip_address = "${var.mapPublicIP}"
  availability_zone = "${var.availabilityZone}"
  key_name = "${aws_key_pair.romikey-tf.key_name}"

  subnet_id = "${aws_subnet.hacktiv8-project-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.hacktiv8-project-sg.id}"]

  provisioner "file" {
    source = "etc/ec2wordpress.sh"
    destination = "/tmp/ec2wordpress.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/ec2wordpress.sh",
      "sudo /tmp/ec2wordpress.sh"
    ]
  }

provisioner "file" {
    source = "etc/000-default.conf"
    destination = "/tmp/000-default.conf"
  }
provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/000-default.conf /etc/apache2/sites-enabled/000-default.conf",
      "sudo chown www-data:www-data /etc/apache2/sites-enabled/000-default.conf"
    ]
  }

  connection {
    user = "${var.instanceUsername}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }
  tags = {
        Name= "hactiv8-project-WP-${count.index}"
    }
}

