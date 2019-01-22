data "template_file" "consul_client_nodeex1" {
  template = "${file("${path.module}/templates/consul.sh.tpl")}"

  vars {
    consul_version = "${var.consul_version}"
    config = <<EOF
     "node_name": "nodeex1",
     "enable_script_checks": true,
     "server": false
    EOF
  }
}

data "template_cloudinit_config" "nodeex_config" {
  part {
    content = "${data.template_file.consul_client_nodeex1.rendered}"
  }
  part {
    content = "${file("${path.module}/templates/node_exporter.sh")}"
  }
}

resource "aws_instance" "node-exporter1" {
  associate_public_ip_address = true
  private_ip = "10.0.1.14"
  ami = "${var.ami_ubuntu16}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public_subnet1.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_default.id}", "${aws_security_group.sg_consul.id}"]
  key_name = "${var.key_name}"
  iam_instance_profile   = "${aws_iam_instance_profile.consul_auto_join.name}"
  tags {
    Name = "node-exporter1"
  }
  user_data = "${data.template_cloudinit_config.nodeex_config.rendered}"
  depends_on = ["aws_instance.consul_server", "aws_instance.prometheus"]
}
