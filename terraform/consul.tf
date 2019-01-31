data "template_file" "consul_server" {
  count    = "${var.consul_servers}"
  template = "${file("${path.module}/templates/consul.sh.tpl")}"

  vars {
    consul_version = "${var.consul_version}"
    config = <<EOF
     "node_name": "consul-server${count.index+1}",
     "server": true,
     "bootstrap_expect": 3,
     "ui": true,
     "client_addr": "0.0.0.0"
    EOF
  }
}

# Create the Consul cluster
resource "aws_instance" "consul_server" {
  count = "${var.consul_servers}"
  ami           = "${var.ami}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public_subnet1.id}"
  key_name      = "${var.key_name}"
  iam_instance_profile   = "${aws_iam_instance_profile.consul_auto_join.name}"
  vpc_security_group_ids = ["${aws_security_group.sg_consul.id}"]

  tags = {
    Name = "consul-server${count.index+1}"
    consul_server = "true"
  }

  user_data = "${element(data.template_file.consul_server.*.rendered, count.index)}"
}
