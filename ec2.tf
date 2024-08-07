resource "aws_instance" "test_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.net-security-group.id]

  tags = {
    Name = "Terraform EC2 Instance"
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -y git docker
                sudo systemctl start docker
                sudo systemctl enable docker
                git clone -b master https://github.com/JadeYookJunnie/MvcMovie.git
                cd MvcMovie
                sudo docker build -t better-reads .
                sudo docker run -d -p 8080:8080 better-reads
                EOF
}