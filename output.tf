output "consul_servers_public_IP" {
  value = ["${aws_instance.consul_server.*.public_ip}"]
}

output "consul_clients_public_IP" {
  value = ["${aws_instance.consul_client.*.public_ip}"]
}


output "Consul" {
  value = "http://${aws_instance.consul_server.*.public_ip[0]}:8500"
}

output "Grafana" {
  value = "http://${aws_instance.grafana.public_ip}:3000"
}

output "Prometheus" {
  value = "curl \"${aws_instance.prometheus.public_ip}:9090\""
}
