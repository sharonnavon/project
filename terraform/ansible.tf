data "template_file" "ansible" {
  template = "${file("${path.module}/templates/ansible.sh.tpl")}"
}

data "template_file" "consul_client_ansible" {
  template = "${file("${path.module}/templates/consul.sh.tpl")}"

  vars {
    consul_version = "${var.consul_version}"
    config = <<EOF
     "node_name": "ansible",
     "enable_script_checks": true,
     "server": false
    EOF
  }
}

data "template_cloudinit_config" "ansible_config" {
  part {
    content = "${data.template_file.consul_client_ansible.rendered}"
  }
  part {
    content = "${data.template_file.ansible.rendered}"
  }
}

resource "aws_instance" "ansible" {
  associate_public_ip_address = true
  ami = "${var.ami}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public_subnet1.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_default.id}", "${aws_security_group.sg_consul.id}"]
  key_name = "${var.key_name}"
  iam_instance_profile   = "${aws_iam_instance_profile.consul_auto_join.name}"
  tags {
    Name = "ansible"
  }

  connection {
    user = "${var.instance_username}"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source = "/home/osboxes/.ssh/aws_ec2.pem"
    destination = "/home/ubuntu/.ssh/aws_ec2.pem"
  }

  provisioner "file" {
    source = "/home/osboxes/.aws"
    destination = "/home/ubuntu"
  }

  user_data = "${data.template_cloudinit_config.ansible_config.rendered}"
#  depends_on = ["aws_instance.consul", "aws_instance.prometheus", "aws_instance.grafana", "aws_instance.elk"]
}
