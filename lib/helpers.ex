defmodule Helpers do
  def keys_to_atoms(tuple) do
    case tuple do
      {:ok, map_list} ->
        {:ok,
         map_list
         |> Enum.map(fn reg ->
           for {key, val} <- reg, into: %{}, do: {String.to_atom(key), val}
         end)}

      {:error, reason} ->
        {:error, reason}

      _ ->
        {:error, "Invalid map"}
    end
  end

  def atom_keys(map) do
    for {key, val} <- map, into: %{} do
      {String.to_atom(key), val}
    end
  end

  @spec parse_int(String.t()) :: integer() | nil
  def parse_int(str) do
    case Integer.parse(str) do
      {int, _remainder} ->
        int

      _ ->
        nil
    end
  end
end
