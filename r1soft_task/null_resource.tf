resource "null_resource" "commands_to_run" { 
 
  provisioner "file" {     
    connection {               
        type            = "ssh"
        user            = "centos"
        private_key     = "${file("~/.ssh/id_rsa")}"  
        host            = "${aws_instance.centos.public_ip}" 
    } 
   source = "r1soft.repo"  
   destination = "/tmp/r1soft.repo" 
  }
  provisioner "remote-exec" {     
    connection {               
        type            = "ssh"
        user            = "centos"
        private_key     = "${file("~/.ssh/id_rsa")}" 
        host            = "${aws_instance.centos.public_ip}" 
    }
    
    inline = [                             
      "sudo mv /tmp/r1soft.repo /etc/yum.repos.d/r1soft.repo",
      "sudo yum install r1soft-cdp-enterprise-server -y",
      "sudo r1soft-setup --user admin --pass superteam --http-port 80",
      "sudo /etc/init.d/cdp-server restart",
    ]
    
    
    inline = [                             
      
      "sudo yum install nfs-utils -y",
      "sudo systemctl start nfs",
      
    ]
  
    inline = [
      # mount EFS volume
      # https://docs.aws.amazon.com/efs/latest/ug/gs-step-three-connect-to-ec2-instance.html
      # create a directory to mount our efs volume to
      "sudo mkdir -p /mnt/efs",
      # mount the efs volume
      "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.r1soft.dns_name}:/ /mnt/efs",
      # create fstab entry to ensure automount on reboots
      # https://docs.aws.amazon.com/efs/latest/ug/mount-fs-auto-mount-onreboot.html#mount-fs-auto-mount-on-creation
      "sudo su -c \"echo '${aws_efs_file_system.r1soft.dns_name}:/ /mnt/efs nfs4 defaults,vers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport 0 0' >> /etc/fstab\""
    ]
  }




}
