provider "aws" {
  region = "us-east-1"

}

resource "aws_instance" "web" {
    ami = "ami-0f34c5ae932e6f0e4"
    instance_type = "t2.micro"
    key_name =   "demo_key" 
    vpc_security_group_ids = [aws_security_group.aws-sg.id]
}


resource "aws_security_group" "aws-sg" {
  name        = "allow_SSH"
  description = "Allow TLS inbound traffic"


  ingress {
    description      = "demo SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {

    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}