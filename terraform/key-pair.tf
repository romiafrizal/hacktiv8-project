resource "aws_key_pair" "romikey-tf" {
  key_name   = "romikey-tf"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}