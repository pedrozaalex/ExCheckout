defmodule ProductsConfig do
  def read_json(file) do
    case File.read(file) do
      {:ok, json} ->
        Jason.decode(json)

      {:error, err} ->
        {:error, "Couldn't read file at #{file}: #{err}"}
    end
  end

  def get_config() do
    config_file_location = Application.get_env(:challenge, :file_location)

    case read_json(config_file_location) do
      {:ok, config} ->
        config

      {:error, reason} ->
        IO.puts(reason)
    end
  end
end
