### Consul ###
resource "aws_iam_role" "consul_auto_join" {
  name = "consul_auto_join"
  assume_role_policy = "${file("${path.module}/templates/policies/assume-role.json")}"
}

resource "aws_iam_policy" "consul_auto_join" {
  name = "consul_auto_join"
  description = "Allows Consul nodes to describe instances for joining"
  policy = "${file("${path.module}/templates/policies/describe-instances.json")}"
}

resource "aws_iam_policy_attachment" "consul_auto_join" {
  name = "consul_auto_join"
  roles = ["${aws_iam_role.consul_auto_join.name}"]
  policy_arn = "${aws_iam_policy.consul_auto_join.arn}"
}

resource "aws_iam_instance_profile" "consul_auto_join" {
  name = "consul_auto_join"
  role = "${aws_iam_role.consul_auto_join.name}"
}
