variable "PROJECT_ID" {
    description = "The GCP project ID"
    type        = string
    default    = "t-pulsar-412422"
}

variable "CREADENTIALS_PATH" {
    description = "The GCP service account credentials path"
    type        = string
    default    = "./t-pulsar-412422-8f261e630db9.json"
  
}

variable "REGION" {
    description = "The GCP region"
    type        = string
    default    = "us-central1"
}

variable "ZONE" {
    description = "The GCP zone"
    type        = string
    default    = "us-central1-b"
}

variable "TF_SERVICE_ACCOUNT" {
    description = "The GCP service account to impersonate"
    type        = string
    default    = "sa-gomicro-tf-mac@t-pulsar-412422.iam.gserviceaccount.com"
}

variable "MACHINE_TYPE" {
    description = "The GCP machine type"
    type        = string
    default    = "t2a-standard-1"
}

variable "DOMAIN" {
    description = "The GCP domain"
    type        = string
    default    = "smoliv.dev"
}