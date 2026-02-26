import Config

config :giocci,
  # Path to Zenoh configuration
  zenoh_config_file_path: "zenoh_config.json5",
  # Unique client identifier
  client_name: "my_client",
  # Optional key prefix for Zenoh keys
  key_prefix: ""
