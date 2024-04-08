resource "aws_instance" "my_server" {
  ami = "ami-0a699202e5027c10d"
  instance_type = "t2.micro"
  key_name = "my_key"
  tags = {
    Name = "my_server"
  }
}

resource "null_resource" "provisioner" {
  connection {
    type = "ssh"
    port = 22
    user = "ec2-user"
    private_key = file(local_file.keypair.filename)
    host = aws_instance.my_server.public_ip
  }

   provisioner "local-exec" {
    command = "echo ${aws_instance.my_server.private_ip} >> serverip.log"
  }

   provisioner "file" {
    source = "serverip.log"
    destination = "/home/ec2-user/serverip.log"
  }

   provisioner "remote-exec" {
    inline = [ 
        "sudo mv serverip.log /opt"
     ]
  }

  depends_on = [ aws_instance.my_server ]
}
   
    
