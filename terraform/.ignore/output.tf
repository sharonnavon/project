output "Consul" {
  value = "http://${aws_instance.consul_server.*.public_ip[0]}:8500"
}
output "Grafana" {
  value = "http://${aws_instance.grafana.public_ip}:3000"
}
output "Prometheus" {
  value = "curl http://${aws_instance.prometheus.public_ip}:9090"
}
output "ElasticSearch" {
  value = "curl http://${aws_instance.elk.public_ip}:9200"
}
output "Kibana" {
  value = "curl http://${aws_instance.elk.public_ip}:5601/app/infra#/logs"
}
output "DummyExporterService1" {
  value = "curl http://${aws_instance.docker_server.*.public_ip[0]}:65433"
}
output "DummyExporterService2" {
  value = "curl http://${aws_instance.docker_server.*.public_ip[1]}:65433"
}
