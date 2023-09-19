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
  
  access_key = "AKIARONOYQPLB2JDO66D"
  secret_key = "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"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "ansible-key" {
  key_name   = "ansible-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6xnOS4Q6zVLSTejAOSw/iPqKj3/qaF18CxgrfRM9d2liLQeuFC1EYnOpy2NlI63YM/1CTsWkPid/zANtrBF0d7GDK/BSkDYO2fw9LsqUF2LuwI0wfGD9+Tpkj38cgTyfqLXsNiPTAZ8HT+thmnglT4R374ZoTSp84vV4YwSiZCHethwwDLUKR6ZO9N4w5QfpExvM2iD9foli6DMa94jvwzx6awqcIsmmC0Yf4PVxDMuIzNc7x5AoQEyoSLX64IZEZYuoRYkwDquAUyI8xC81dSc6DpgJOV2NwzFDm4SXqhA3IQVoVT1XkvBLpRSkkLXlfkcf8suVH032TYObOQ4XQM69fcn5c1SQui9AK+9UTtUhoQHrGN19D8nw1qaL8YKqf2F4y68OdA0XhdS++xJqPISrEj5yhE8V/VzG+s6pZsxtBT1iVf+zkQl2bg+1aY/TUMgdtZZ9APeHIP81cknXyQGbEZn/ymr2Wt55sHBuJ8qJaYpmjp8/4YxtKBmvf8zk= root@ip-172-31-24-77"
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "ansible-key"
  tags = {
    Name = "jenkins"
  }
}

output "private_ip" {
  value = aws_instance.jenkins.private_ip
}
