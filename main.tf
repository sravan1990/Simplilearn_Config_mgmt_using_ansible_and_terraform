provider "aws" {
  region = "us-east-1"
  access_key = "AKIAVUHCYSQRRD64A53J"
  secret_key = "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"
}

resource "aws_security_group" "nginx-sg" {
  name = "terraform-security-group-sg-8080"
 ingress {
        from_port   =   0
        to_port     =   0
        protocol    =   "-1"
        cidr_blocks =   ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // connectivity to ubuntu mirrors is required to run `apt-get update` and `apt-get install apache2`

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "remote_server" {
    ami = "ami-0e2c8caa4b6378d8c"
    count = "1"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.nginx-sg.id]
    key_name = "nginx-key"

    tags = {
        name = "remote_server"
    }

}

resource "aws_key_pair" "nginx_key" {
  key_name   = "nginx-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCWK7uxXCsae6Xzu8ZYbHpvXhXKSIbjOcn/YC31vqn1C6THwJfXZl35dPChuGC8VvF97OEfZGCvFUxZ9FN6usqTvhaGHLtvgZ3ENuRdp7I6qPkH8YiK7MpFtrei/tYAkjLxMGgDDpf5kISddPRkjliQjjd63i8wlHtPdV3iiSVwxHCWn9zjeWjKsB9yOz1u+Im/UE3mIxBs29O53x52eIdOtln/B0s2NbccJQlHlcXCIz/KXdWOCC2m9dyyARYAcDVfrNCuF8bTfLhteyPhba4/+MY73Ma8tTn0sn6gaGm3Im1yQLRtAic7ZAINZlm8/9s7hPhUxN1HIxPS0xXHhLtr nginx-key"
}