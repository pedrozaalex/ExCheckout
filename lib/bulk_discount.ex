defmodule BulkDiscount do
  @moduledoc """
  Bulk discounts module. Bulk discounts are discounts of the
  type "if at least X products of type T are bought,
  then all products of type T are free".
  """

  defstruct min: 0, bulkPrice: 0.0

  def get_all_from_config() do
    ProductsConfig.get_config()
    |> Map.get("discounts")
    |> Map.get("bulk")
  end

  @doc """
  Applies bulk discounts to the cart.
  """
  @spec apply_discounts([Product.t()], %{required(String.t()) => BulkDiscount}) :: [Product.t()]
  def apply_discounts(cart, bulk_discounts) do
    bulk_discounts
    |> Enum.reduce(cart, fn {product_code, discount}, acc ->
      min_qty = discount |> Map.get("min")
      bulk_price = discount |> Map.get("bulkPrice")
      qty = Helpers.count_item_in_cart(cart, product_code)

      if qty >= min_qty do
        acc
        |> Helpers.update_n_cart_items(qty, product_code, fn x ->
          x |> Map.put(:price, bulk_price)
        end)
      else
        acc
      end
    end)
  end
end
