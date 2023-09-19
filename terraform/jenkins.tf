terraform {

  required_providers {

    aws = {

      source = "hashicorp/aws"

      version = "5.17.0"

    }

  }

}


provider "aws" {

  # Configuration options

  region = "us-east-1"
  access_key = "AKIARONOYQPLB2JDO66D"
  secret_key = "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"
}

resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-sg"
  description = "Allow inbound SSH and HTTP"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
     description = "HTTP"
     from_port   = 8080
     to_port     = 8080
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
   
  egress {
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"]
   }
}

resource "aws_key_pair" "ansible-key" {
  key_name   = "ansible-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6xnOS4Q6zVLSTejAOSw/iPqKj3/qaF18CxgrfRM9d2liLQeuFC1EYnOpy2NlI63YM/1CTsWkPid/zANtrBF0d7GDK/BSkDYO2fw9LsqUF2LuwI0wfGD9+Tpkj38cgTyfqLXsNiPTAZ8HT+thmnglT4R374ZoTSp84vV4YwSiZCHethwwDLUKR6ZO9N4w5QfpExvM2iD9foli6DMa94jvwzx6awqcIsmmC0Yf4PVxDMuIzNc7x5AoQEyoSLX64IZEZYuoRYkwDquAUyI8xC81dSc6DpgJOV2NwzFDm4SXqhA3IQVoVT1XkvBLpRSkkLXlfkcf8suVH032TYObOQ4XQM69fcn5c1SQui9AK+9UTtUhoQHrGN19D8nw1qaL8YKqf2F4y68OdA0XhdS++xJqPISrEj5yhE8V/VzG+s6pZsxtBT1iVf+zkQl2bg+1aY/TUMgdtZZ9APeHIP81cknXyQGbEZn/ymr2Wt55sHBuJ8qJaYpmjp8/4YxtKBmvf8zk= root@ip-172-31-24-77"
}

resource "aws_instance" "jenkins" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name = "ansible-key"
  tags = {
    Name = "jenkins"
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment1" {
  security_group_id = aws_security_group.jenkins-sg.id
  network_interface_id = aws_instance.jenkins.primary_network_interface_id
}
