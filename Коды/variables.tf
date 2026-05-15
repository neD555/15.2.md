variable "service_account_key_file" {
  type    = string
  default = "key.json"
}

variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "service_account_id" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "image_file_path" {
  type    = string
  default = "image.jpg"
}

variable "image_object_name" {
  type    = string
  default = "image.jpg"
}

variable "vm_user" {
  type    = string
  default = "ubuntu"
}

variable "public_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}
