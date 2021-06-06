

# Variables
| Name | Description | Default Value |
|---|---|---|
| `project` | The project ID |  |
| `region` | The region | `"europe-north1"` |
| `zone` | The zone inside the region | `"europe-north1-a"` |
| `prefix` | Name prefix for resources | `"toggl-test"` |
| `postgres_version` | The engine version of the database, e.g. `POSTGRES_9_6`. See https://cloud.google.com/sql/docs/features for supported versions. | `"POSTGRES_13"` |
| `db_machine_type` | The machine type for the instances. See this page for supported tiers and pricing: https://cloud.google.com/sql/pricing | `"db-f1-micro"` |
| `master_user_name` | The username part for the default user credentials, i.e. 'master_user_name'@'master_user_host' IDENTIFIED BY 'master_user_password'. This should typically be set as the environment variable TF_VAR_master_user_name so you don't check it into source control. | `"postgres"` |
| `master_user_password` | The password part for the default user credentials, i.e. 'master_user_name'@'master_user_host' IDENTIFIED BY 'master_user_password'. This should typically be set as the environment variable TF_VAR_master_user_password so you don't check it into source control. |  |

# TODO
- use modules
