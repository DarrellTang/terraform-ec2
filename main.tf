provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"

  version = "~> 2.0"
}

resource "aws_instance" "test-instance" {
  ami             = "ami-074e2d6769f445be5"
  instance_type   = "${var.instance_type}"
  key_name        = "${aws_key_pair.my-test-key.key_name}"


  security_groups = [
    "${aws_security_group.allow_ssh.name}",
    "${aws_security_group.allow_outbound.name}"
  ]
  provisioner "file" {
    source      = "${var.upload_filename}"
    destination = "/tmp/${var.upload_filename}"
    connection {
      type        = "ssh"
      host = self.public_ip
      user        = "centos"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

  tags = {
    Name = "${var.instance_name}"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_outbound" {
  name        = "allow-all-outbound"
  description = "Allow all outbound traffic"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "my-test-key" {
  key_name   = "public-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}