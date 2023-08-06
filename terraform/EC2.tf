provider "aws" {
  region = "us-east-1"

}

resource "aws_instance" "app-server" {
    ami = "ami-0f34c5ae932e6f0e4"
    instance_type = "t2.micro"
    key_name =   "demo_key" 
    vpc_security_group_ids = [aws_security_group.app-sg.id]
    subnet_id = aws_subnet.app-public_subnet_01.id
}


resource "aws_security_group" "app-sg" {
  name        = "allow_SSH"
  description = "Allow TLS inbound traffic"
  vpc_id = aws_vpc.app-vpc.id


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

resource "aws_vpc" "app-vpc" {
       cidr_block = "10.1.0.0/16"
       tags = {
        Name = "app-vpc"
     }
}

//Create a Subnet 1
resource "aws_subnet" "app-public_subnet_01" {
    vpc_id = aws_vpc.app-vpc.id
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
      Name = "app-public_subent_01"
    }
}   

//Create a Subnet 2
resource "aws_subnet" "app-public_subnet_02" {
    vpc_id = aws_vpc.app-vpc.id
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
      Name = "app-public_subent_02"
    }
}  

//Creating an Internet Gateway 
resource "aws_internet_gateway" "app-igw" {
    vpc_id = aws_vpc.app-vpc.id
    tags = {
      Name = "app-igw"
    }
}


// Create a route table 
resource "aws_route_table" "app-public-rt" {
    vpc_id = aws_vpc.app-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.app-igw.id
    }
    tags = {
      Name = "app-public-rt"
    }
}

// Associate subnet with route table

resource "aws_route_table_association" "app-rta-public-subnet-01" {
    subnet_id = aws_subnet.app-public_subnet_01.id
    route_table_id = aws_route_table.app-public-rt.id
}
resource "aws_route_table_association" "app-rta-public-subnet-02" {
    subnet_id = aws_subnet.app-public_subnet_02.id
    route_table_id = aws_route_table.app-public-rt.id
}


