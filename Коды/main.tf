terraform {
  required_version = ">= 1.3.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.130.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = file(var.service_account_key_file)
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_iam_service_account_static_access_key" "storage_key" {
  service_account_id = var.service_account_id
  description        = "Static access key for Object Storage"
}

resource "yandex_storage_bucket" "bucket" {
  bucket     = var.bucket_name
  access_key = yandex_iam_service_account_static_access_key.storage_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.storage_key.secret_key

  anonymous_access_flags {
    read = true
    list = false
  }
}

resource "yandex_storage_object" "image" {
  bucket       = yandex_storage_bucket.bucket.bucket
  key          = var.image_object_name
  source       = var.image_file_path
  access_key   = yandex_iam_service_account_static_access_key.storage_key.access_key
  secret_key   = yandex_iam_service_account_static_access_key.storage_key.secret_key
  acl          = "public-read"
  content_type = "image/jpeg"
}

resource "yandex_vpc_network" "network" {
  name = "lamp-network"
}

resource "yandex_vpc_subnet" "public" {
  name           = "lamp-public"
  zone           = var.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.30.0/24"]
}

resource "yandex_compute_instance_group" "lamp_group" {
  name               = "lamp-instance-group"
  folder_id          = var.folder_id
  service_account_id = var.service_account_id

  depends_on = [
    yandex_storage_object.image
  ]

  instance_template {
    platform_id = "standard-v3"

    resources {
      cores  = 2
      memory = 2
    }

    boot_disk {
      mode = "READ_WRITE"

      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 10
      }
    }

    network_interface {
      network_id = yandex_vpc_network.network.id
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat        = true
    }

    metadata = {
      ssh-keys = "${var.vm_user}:${file(var.public_key_path)}"

      user-data = <<-USERDATA
        #cloud-config
        package_update: true
        runcmd:
          - |
            cat > /var/www/html/index.html <<HTML
            <!DOCTYPE html>
            <html>
            <head>
              <meta charset="UTF-8">
              <title>Netology LAMP</title>
            </head>
            <body>
              <h1>Netology LAMP Instance Group</h1>
              <p>Image from Yandex Object Storage:</p>
              <img src="${local.image_url}" style="max-width: 600px;">
            </body>
            </html>
            HTML
          - systemctl restart apache2
      USERDATA
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 1
  }

  health_check {
    interval = 10
    timeout  = 5

    http_options {
      port = 80
      path = "/"
    }
  }

  load_balancer {
    target_group_name = "lamp-target-group"
  }
}

resource "yandex_lb_network_load_balancer" "lamp_lb" {
  name = "lamp-network-load-balancer"

  listener {
    name = "lamp-listener"
    port = 80

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = tolist(yandex_compute_instance_group.lamp_group.load_balancer)[0].target_group_id

    healthcheck {
      name = "http-healthcheck"

      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

locals {
  image_url = "https://storage.yandexcloud.net/${var.bucket_name}/${var.image_object_name}"
}
