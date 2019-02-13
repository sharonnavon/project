data "template_file" "consul_client_grafana" {
  template = "${file("${path.module}/templates/consul.sh.tpl")}"

  vars {
    consul_version = "${var.consul_version}"
    config = <<EOF
     "node_name": "grafana",
     "enable_script_checks": true,
     "server": false
    EOF
  }
}

data "template_file" "grafana_install" {
  template = "${file("${path.module}/templates/grafana.sh.tpl")}"
}

data "template_cloudinit_config" "grafana_config" {
  part {
    content = "${data.template_file.consul_client_grafana.rendered}"
  }
  part {
    content = "${data.template_file.grafana_install.rendered}"
  }
}

resource "aws_instance" "grafana" {
  associate_public_ip_address = true
  ami = "${var.ami}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public_subnet1.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_default.id}", "${aws_security_group.sg_consul.id}"]
  key_name = "${var.key_name}"
  iam_instance_profile   = "${aws_iam_instance_profile.consul_auto_join.name}"
  tags {
    Name = "grafana"
  }
  user_data = "${data.template_cloudinit_config.grafana_config.rendered}"
  depends_on = ["aws_instance.consul_server", "aws_instance.prometheus"]
}
