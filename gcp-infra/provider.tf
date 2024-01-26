provider "google" {
  project     = var.PROJECT_ID
  region      = var.REGION
  zone       = var.ZONE
  impersonate_service_account = var.TF_SERVICE_ACCOUNT
  credentials = file(var.CREADENTIALS_PATH)
}