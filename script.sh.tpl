curl -L https://storage.googleapis.com/${bucket_name}/main -o /root/main
chmod +x /root/main

echo '{
  "http_port": ${port},
  "db_connstring": "postgresql://${master_user_name}:${master_user_password}@${sql_ip_address}"
}' > /root/config.json
nohup /root/main --config-file /root/config.json &