defmodule ProductsConfig do
  @spec read_json(
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | char,
              binary | []
            )
        ) :: {:error, <<_::64, _::_*8>> | Jason.DecodeError.t()} | {:ok, any}
  defp read_json(file) do
    case File.read(file) do
      {:ok, json} ->
        Jason.decode(json)

      {:error, err} ->
        {:error, "Couldn't read file at #{file}: #{err}"}
    end
  end

  @doc """
  Reads the products configuration file.
  """
  @spec get_config :: map()
  def get_config() do
    config_file_location = Application.get_env(:challenge, :file_location)

    case read_json(config_file_location) do
      {:ok, config} ->
        config

      {:error, reason} ->
        IO.puts(reason)
        %{}
    end
  end
end
