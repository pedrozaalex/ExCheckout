import Config

config :challenge,
  file_location: System.get_env("PRODUCTS_FILE_LOCATION", "products_config.json")
