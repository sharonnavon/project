data "template_file" "consul_client_docker" {
  count = "${var.docker_servers}"
  template = "${file("${path.module}/templates/consul.sh.tpl")}"

  vars {
    consul_version = "${var.consul_version}"
    config = <<EOF
     "node_name": "docker-server${count.index+1}",
     "enable_script_checks": true,
     "server": false
    EOF
  }
}

data "template_file" "docker_install" {
  template = "${file("${path.module}/templates/docker.sh.tpl")}"

  vars {
    elk_priv_ip = "${aws_instance.elk.private_ip}"
  }
}

data "template_cloudinit_config" "docker_server_config" {
  count = "${var.docker_servers}"
  part {
    content = "${element(data.template_file.consul_client_docker.*.rendered, count.index)}"
  }
  part {
    content = "${data.template_file.docker_install.rendered}"
  }
}

resource "aws_instance" "docker_server" {
  count = "${var.docker_servers}"
  associate_public_ip_address = true
  ami = "${var.ami}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public_subnet1.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_default.id}", "${aws_security_group.sg_consul.id}"]
  key_name = "${var.key_name}"
  iam_instance_profile   = "${aws_iam_instance_profile.consul_auto_join.name}"
  tags {
    Name = "docker-server${count.index+1}"
  }
  user_data = "${element(data.template_cloudinit_config.docker_server_config.*.rendered, count.index)}"
  depends_on = ["aws_instance.consul_server", "aws_instance.prometheus", "aws_instance.elk"]
}
