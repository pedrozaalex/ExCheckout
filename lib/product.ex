defmodule Product do
  defstruct id: "", name: "", price: 0.0

  def get_all_from_config() do
    ProductsConfig.get_config()
    |> Map.get("products")
    |> Enum.map(fn p -> Helpers.atom_keys(p) end)
    |> Enum.map(fn p -> struct!(Product, p) end)
    |> Enum.filter(fn p -> Product.is_valid?(p) end)
  end

  @doc """
  Turns a list of products into a string representation

  """
  def catalog_to_string(catalog) do
    catalog
    |> Enum.with_index(1)
    |> Enum.map(fn {item, index} -> "(#{index}) #{Product.print(item)}" end)
    |> Enum.join("\n")
  end

  def is_valid_price?(product) when is_map(product),
    do: Map.has_key?(product, :price) && is_number(product.price)

  def is_valid_id?(product) when is_map(product),
    do: Map.has_key?(product, :id) && is_binary(product.id)

  def is_valid_name?(product) when is_map(product),
    do: Map.has_key?(product, :name) && is_binary(product.name)

  def is_valid?(product) when is_map(product) do
    is_valid_id?(product) &&
      is_valid_name?(product) &&
      is_valid_price?(product)
  end

  def is_valid?(_) do
    false
  end

  def print(product) when is_map(product) do
    "#{String.pad_trailing(product.name, 10)}\t" <>
      "#{String.pad_trailing(Float.to_string(product.price), 10)}"
  end

  def print(_), do: nil
end
