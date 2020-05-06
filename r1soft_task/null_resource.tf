resource "null_resource" "commands_to_run" { 
 
  provisioner "file" {     //
    connection {               //this is how i connect provisioner to instance with parameters. it means us thiese parameters and perform task in the provisioner.
        type            = "ssh"
        user            = "centos"
        private_key     = "${file("~/.ssh/id_rsa")}" // aws not allow me to connect password so private key location need to provided. 
        host            = "${aws_instance.centos.public_ip}" //it mmeans do ssh and find instance's ip address
    } 
   source = "r1soft.repo"  #machine that you are executing the terraform code 
   destination = "/tmp/r1soft.repo" #instance that you are creating with your terraform code.
  }
  provisioner "remote-exec" {     //
    connection {               //this is how i connect provisioner to instance with parameters. it means us thiese parameters and perform task in the provisioner.
        type            = "ssh"
        user            = "centos"
        private_key     = "${file("~/.ssh/id_rsa")}" // aws not allow me to connect password so private key location need to provided. 
        host            = "${aws_instance.centos.public_ip}" //it mmeans do ssh and find instance's ip address
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


  }

  

 
}
