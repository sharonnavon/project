resource "aws_instance" "prometheus" {
  associate_public_ip_address = true
  ami = "${var.ami}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public_subnet1.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_default.id}", "${aws_security_group.sg_consul.id}"]
  key_name = "${var.key_name}"
  iam_instance_profile   = "${aws_iam_instance_profile.consul_auto_join.name}"
  tags {
    Name = "prometheus"
  }
  user_data = "${file("${path.module}/templates/basic_instance.sh")}"
}

resource "aws_instance" "consul" {
  count = "${var.consul_servers}"
  ami           = "${var.ami}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public_subnet1.id}"
  key_name      = "${var.key_name}"
  iam_instance_profile   = "${aws_iam_instance_profile.consul_auto_join.name}"
  vpc_security_group_ids = ["${aws_security_group.sg_consul.id}"]

  tags = {
    Name = "consul${count.index+1}"
    consul_server = "true"
  }

  user_data = "${file("${path.module}/templates/basic_instance.sh")}"
}
