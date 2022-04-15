defmodule InputTest do
  use ExUnit.Case
  doctest(ProductsConfig)

  test "read products from json file" do
    case ProductsConfig.read_json("products_config.json") do
      {:ok, products} ->
        assert products != nil

      {:error, reason} ->
        assert nil, reason
    end
  end

  test "throws error when reading invalid json file" do
    with {:error, reason} <- ProductsConfig.read_json("invalid.json") do
      assert is_binary(reason)
    end
  end
end
