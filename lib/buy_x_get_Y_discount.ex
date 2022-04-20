defmodule BuyXGetYDiscount do
  defstruct buy: 0, get: 0

  def get_all_from_config() do
    ProductsConfig.get_config()
    |> Map.get("discounts")
    |> Map.get("buyXgetY")
  end

  @doc """
  Applies buy X get Y discounts to the cart.
  """
  @spec apply_discounts([Product.t()], %{required(String.t()) => BuyXGetYDiscount}) :: any
  def apply_discounts(cart, discounts) do
    discounts
    |> Map.to_list()
    |> Enum.reduce(cart, fn {product_code, discount}, acc ->
      buy_qty = discount["buy"]
      get_qty = discount["get"]

      cart_qty = Helpers.count_item_in_cart(acc, product_code)

      if cart_qty >= buy_qty do
        qty_items_to_update = get_qty * (cart_qty |> div(buy_qty))

        acc
        |> Helpers.update_n_cart_items(
          qty_items_to_update,
          product_code,
          fn x ->
            IO.puts("Applying buy #{buy_qty} and get #{get_qty} discount for #{product_code}")
            x |> Map.put(:price, 0.0)
          end
        )
      else
        acc
      end
    end)
  end
end
