provider "aws" {
  access_key = "AKIAIQY4VG7C5RTBN4QQ"
  secret_key = "u0vxPK5HrPn2nDnlj3QSxZOioQAUnvrAoDC130nV"
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-c80b0aa2"
  instance_type = "t2.micro"
  subnet_id = "subnet-e75d10be"
  security_groups = [ "${aws_security_group.sg.id}" ]
}

resource "aws_elb" "elb" {
  name = "${var.name}"
  security_groups = [ "${aws_security_group.sg.id}" ]
  subnets = "${var.subnets}"
  cross_zone_load_balancing = true
  instances = ["${aws_instance.example.id}"]

  listener {
    instance_port = "80"
    instance_protocol = "tcp"
    lb_port = "80"
    lb_protocol = "tcp"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/check"
    interval = 5
  }
  tags {
    Name = "${var.name}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "sg" {
  name = "${var.name}-sg"
  description = "Allow all inbound traffic"
  vpc_id = "${var.vpc_id}"
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}
