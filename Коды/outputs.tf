output "bucket_name" {
  value = yandex_storage_bucket.bucket.bucket
}

output "image_url" {
  value = local.image_url
}

output "load_balancer_ip" {
  value = tolist(tolist(yandex_lb_network_load_balancer.lamp_lb.listener)[0].external_address_spec)[0].address
}

output "instance_group_id" {
  value = yandex_compute_instance_group.lamp_group.id
}

output "target_group_id" {
  value = tolist(yandex_compute_instance_group.lamp_group.load_balancer)[0].target_group_id
}
