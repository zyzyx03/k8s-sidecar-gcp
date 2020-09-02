// db module

resource "google_sql_database" "main" {
  name     = "main"
  instance = google_sql_database_instance.main_primary.name
}

resource "google_sql_database_instance" "main_primary" {
  name             = "pyzine-mysql-1"
  database_version = "MYSQL_5_7"

  settings {
    tier              = var.instance_type
    availability_type = "ZONAL" 
    disk_size         = var.disk_size

    ip_configuration {
      ipv4_enabled    = true    
    }
  }
}

resource "google_sql_user" "db_user" {
  name     = var.user
  instance = google_sql_database_instance.main_primary.name
  password = var.password
}
