#output "ip_addresses" {
#  value = aws_network_interface.master.*.private_ips
#}

output "master_autoscaling_groups" {
  value = [
    aws_autoscaling_group.master-az-a.name,
    aws_autoscaling_group.master-az-b.name,
    aws_autoscaling_group.master-az-c.name,
  ]
}
