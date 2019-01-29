data "template_file" "consul_client_prometheus" {
  template = "${file("${path.module}/templates/consul.sh.tpl")}"

  vars {
    consul_version = "${var.consul_version}"
    config = <<EOF
     "node_name": "prometheus",
     "enable_script_checks": true,
     "server": false
    EOF
  }
}

data "template_cloudinit_config" "prometheus_config" {
  part {
    content = "${data.template_file.consul_client_prometheus.rendered}"
  }
  part {
    content = "${file("${path.module}/templates/prometheus.sh")}"
  }
}

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
  user_data = "${data.template_cloudinit_config.prometheus_config.rendered}"
  depends_on = ["aws_instance.consul_server"]
}
