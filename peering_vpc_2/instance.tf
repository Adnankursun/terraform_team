
resource "aws_instance" "bastion" {
  ami           = "ami-0affd4508a5d2481b"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id = "${aws_subnet.public1.id}"
  security_groups = ["${aws_security_group.bastion.id}"]
  key_name = "${aws_key_pair.local.key_name}"


  tags = {
    Name = "Bastion"
    Team = "admins"
  }
}

resource "aws_instance" "Backup" {
  ami           = "ami-0affd4508a5d2481b"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.private1.id}"
  security_groups = ["${aws_security_group.backup.id}"]


  tags = {
    Name = "Backup"
    Team = "DB"
  }
  
}


