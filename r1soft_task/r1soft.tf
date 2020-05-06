provider "aws" {
  region  = "us-east-2" 
  
}
data "aws_ami" "centos" {   // resource name has to be different. ex : centos6 , centos7
  most_recent = true   /// find latest
  owners      = ["679593333241"]  // this iwner id never change all centos have same number
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"] // this value is ami and ami name doesn't need to mentioned as long as centos7, centos6, it is find
  }

}

resource "aws_instance" "centos" {
  ami           = "${data.aws_ami.centos.id}" //this is ami created earlier
  instance_type = "t2.micro"     
  key_name      =   "${aws_key_pair.eu-west-2-key.key_name}"
  associate_public_ip_address = "true"
  subnet_id = "${aws_subnet.public2.id}"
  security_groups = ["${aws_security_group.r1soft.id}"]
  tags = {
    Name = "r1soft"
    Team = "admins"
  }

 
}
 
