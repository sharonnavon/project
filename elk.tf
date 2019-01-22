//resource "aws_instance" "elk" {
//  associate_public_ip_address = true
//  private_ip = "10.0.1.13"
//  ami = "${var.ami}"
//  instance_type = "t2.micro"
//  subnet_id = "${aws_subnet.public_subnet1.id}"
//  vpc_security_group_ids = ["${aws_security_group.sg_default.id}"]
//  key_name = "${var.key_name}"
//  tags {
//    Name = "elk"
//  }
//
//  connection {
//    user = "${var.instance_username}"
//    private_key = "${file(var.private_key_path)}"
//  }
//
//  provisioner "remote-exec" {
//    inline = [
//      "sudo sed -i 's/us-east-1.ec2.//g' /etc/apt/sources.list",
//      "sudo apt -qq update",
//      "sudo apt install -y python"
//    ]
//  }
//}
//