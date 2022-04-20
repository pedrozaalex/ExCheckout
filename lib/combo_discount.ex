defmodule ComboDiscount do
  defstruct items: [], price: 0.0

  def get_all_from_config() do
    ProductsConfig.get_config()
    |> Map.get("discounts")
    |> Map.get("combo")
  end

  defp check_if_cart_has_X_items(cart, code, qty) do
    qty_in_cart = Helpers.count_item_in_cart(cart, code)

    qty_in_cart >= qty
  end

  @doc """
  Returns true if the cart has the required items for a given combo
  """
  @spec check_if_cart_has_combo(any, nil | maybe_improper_list | map) :: any
  def check_if_cart_has_combo(cart, combo) do
    combo["items"]
    |> Enum.reduce(true, fn {code, qty}, acc ->
      if not acc, do: false, else: check_if_cart_has_X_items(cart, code, qty)
    end)
  end

  defp apply_one_combo(cart, combo) do
    if cart |> check_if_cart_has_combo(combo) do
      IO.puts("Applying combo: #{combo["name"]}")

      new_cart =
        combo["items"]
        |> Enum.reduce(cart, fn {product_code, qty}, acc ->
          # remove combo items from cart
          acc |> Helpers.remove_item_from_cart(product_code, qty)
        end)
        # Add combo to list
        |> Kernel.++([%{id: combo["id"], price: combo["price"], name: combo["name"]}])

      if new_cart |> check_if_cart_has_combo(combo) do
        apply_one_combo(new_cart, combo)
      else
        new_cart
      end
    else
      cart
    end
  end

  @doc """
  Applies combo discounts to the cart.
  """
  @spec apply_discounts([Product.t()], [ComboDiscount]) :: [Product.t()]
  def apply_discounts(cart, combos) do
    combos
    |> Enum.reduce(cart, fn combo, acc ->
      acc |> apply_one_combo(combo)
    end)
  end
end
