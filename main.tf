resource "aws_instance" "terraform" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  tags = {
    Name = var.instances
    Terraform="true"
  }
}
resource "aws_ebs_volume" "data" {
  availability_zone = "us-east-1"
  size              = 50
  type              = "gp3"
}

resource "aws_volume_attachment" "data" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.data.id
  instance_id = aws_instance.terraform.id
  user_data=file("eksctl-script.sh")
}

resource "aws_security_group" "allow_all" {
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_all"
  }
}