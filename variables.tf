variable "project" {
  description = "The project ID"
  type        = string
}

variable "region" {
  description = "The region"
  type        = string
  default     = "europe-north1"
}

variable "zone" {
  description = "The zone inside the region"
  type        = string
  default     = "europe-north1-a"
}

variable "prefix" {
  description = "Name prefix for resources"
  type        = string
  default     = "toggl-test"
}

# Postres
variable "postgres_version" {
  description = "The engine version of the database, e.g. `POSTGRES_9_6`. See https://cloud.google.com/sql/docs/features for supported versions."
  type        = string
  default     = "POSTGRES_13"
}

variable "db_machine_type" {
  description = "The machine type for the instances. See this page for supported tiers and pricing: https://cloud.google.com/sql/pricing"
  type        = string
  default     = "db-f1-micro"
}

variable "master_user_name" {
  description = "The password part for the default user credentials, i.e. 'master_user_name'@'master_user_host' IDENTIFIED BY 'master_user_password'. This should typically be set as the environment variable TF_VAR_master_user_password so you don't check it into source control."
  type        = string
  default     = "postgres"
}

variable "master_user_password" {
  description = "The username part for the default user credentials, i.e. 'master_user_name'@'master_user_host' IDENTIFIED BY 'master_user_password'. This should typically be set as the environment variable TF_VAR_master_user_name so you don't check it into source control."
  type        = string
}

