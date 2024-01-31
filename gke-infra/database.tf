resource "google_sql_database_instance" "default" {
  name                = "my-postgres-db"
  database_version    = "POSTGRES_15"
  region              = var.ZONE
  deletion_protection = false

  settings {
    tier = "db-f1-micro"

    backup_configuration {
      enabled = true
    }
  }
}

resource "google_sql_database" "default" {
  name     = "users"
  instance = google_sql_database_instance.default.name
}

resource "google_sql_user" "default" {
  name     = "postgres"
  instance = google_sql_database_instance.default.name
  password = "password"
}
