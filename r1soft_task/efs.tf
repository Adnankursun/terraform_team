resource "aws_efs_file_system" "r1soft" {
  creation_token = "backup"

  tags = {
    Name = "Team3"
  }
}


resource "aws_efs_mount_target" "r1soft" {
  file_system_id = "${aws_efs_file_system.r1soft.id}"
  subnet_id      = "${aws_subnet.public2.id}"
}

