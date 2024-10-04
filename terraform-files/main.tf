resource "aws_instance" "test-server" {
  ami = "ami-0e86e20dae9224db8"
  instance_type = "t3.medium"
  key_name = "mynew"
  vpc_security_group_ids = ["sg-0b61d0a1cfdcff7b3"]
  connection{
     type = "ssh"
     user = "ubuntu"
     private_key = file("./mynew.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
    Name = "test-server"
    }
  provisioner "local-exec" {  
    command = "echo ${aws_instance.test-server.public_ip} > inventory"
    }
  provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/star-agile-banking-finance/terraform-files/ansibleplaybook.yml"
    }
  }  
