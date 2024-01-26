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
    default    = "us-west1"
}

variable "ZONE" {
    description = "The GCP zone"
    type        = string
    default    = "us-west1-b"
}

variable "TF_SERVICE_ACCOUNT" {
    description = "The GCP service account to impersonate"
    type        = string
    default    = "sa-gomicro-tf-mac@t-pulsar-412422.iam.gserviceaccount.com"
}