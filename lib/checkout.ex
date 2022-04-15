defmodule Checkout do
  @moduledoc """
  Checkout module.
  """

  @doc """
  Entry point for checkout.

  """
  def start do
    products = Product.get_all_from_config()

    bulks = BulkDiscount.get_all_from_config()

    buy_X_get_Y = BuyXGetYDiscount.get_all_from_config()

    total =
      prompt_for_cart_products(products, [], :continue)
      |> calculate_total(products, bulks, buy_X_get_Y)

    IO.puts("Total: #{total}€")
  end

  @spec get_products_selection_prompt({Product}, [String.t()]) :: String.t()
  def get_products_selection_prompt(catalog, cart) do
    "\n\nPlease select an item by entering it's number or a list of numbers separated by a space: \n\n" <>
      Product.catalog_to_string(catalog) <>
      "\n\n(0) Finish\n\n" <>
      "Products in cart: " <> (cart |> Enum.join(", ")) <> "\n\nYour selection: "
  end

  def calculate_total(cart, catalog, bulk_discounts, buy_X_get_Y_discounts) do
    cart
    |> sum_cart_products_qty()
    |> apply_buy_X_get_Y_discounts(buy_X_get_Y_discounts)
    |> apply_bulk_discounts(catalog, bulk_discounts)
  end

  def get_product_by_index(catalog, index) do
    try do
      catalog |> elem(index - 1)
    rescue
      _ -> %{}
    end
  end

  def to_product_code_list(index_list, catalog) do
    index_list
    |> Enum.map(fn code ->
      catalog
      |> List.to_tuple()
      |> get_product_by_index(code)
      |> Map.get(:id)
    end)
    |> Enum.filter(fn x -> x != %{} end)
  end

  @spec prompt_for_cart_products([Product], [String.t()], :continue | :stop) :: any
  def prompt_for_cart_products(catalog, cart, :continue) do
    code_or_list =
      try do
        input = get_products_selection_prompt(catalog, cart) |> IO.gets() |> String.trim()

        if input =~ ~r/^(\d ){2,}/ do
          input
          |> String.split(" ")
          |> Enum.map(&String.to_integer(&1))
        else
          input |> String.first() |> String.to_integer()
        end
      rescue
        _ ->
          nil
      end

    cond do
      code_or_list == 0 ->
        prompt_for_cart_products(catalog, cart, :stop)

      is_list(code_or_list) ->
        newItems =
          code_or_list
          |> Enum.filter(&(is_integer(&1) && 0 < &1 && &1 <= length(code_or_list)))
          |> to_product_code_list(catalog)

        prompt_for_cart_products(catalog, cart ++ newItems, :continue)

      true ->
        try do
          product = catalog |> List.to_tuple() |> elem(code_or_list - 1)

          if product === nil do
            IO.puts("Product not found")
            prompt_for_cart_products(catalog, cart, :continue)
          else
            prompt_for_cart_products(catalog, cart ++ [product.id], :continue)
          end
        rescue
          _ ->
            IO.puts("Invalid selection")
            prompt_for_cart_products(catalog, cart, :continue)
        end
    end
  end

  # @spec prompt_for_cart_products({Product}, [String.t()], :stop) :: {Product}
  def prompt_for_cart_products(_, cart, :stop), do: cart

  def sum_cart_products_qty(cart) do
    cart |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end

  def apply_bulk_discounts(cart, catalog, discounts) do
    cart
    |> Enum.reduce(0.0, fn {product_code, qty}, acc ->
      if discounts |> Map.has_key?(product_code) do
        minQty = discounts[product_code]["min"]
        discountedPrice = discounts[product_code]["bulkPrice"]

        originalPrice = catalog |> Enum.find(fn p -> p.id == product_code end) |> Map.get(:price)

        acc + qty * if qty >= minQty, do: discountedPrice, else: originalPrice
      else
        price = catalog |> Enum.find(fn p -> p.id == product_code end) |> Map.get(:price)

        acc + qty * price
      end
    end)
  end

  def apply_buy_X_get_Y_discounts(cart, discounts) do
    cart
    |> Enum.reduce(%{}, fn {product_code, qty}, acc ->
      if discounts |> Map.has_key?(product_code) do
        buyX = discounts[product_code]["buy"]
        getY = discounts[product_code]["get"]

        newQty =
          if(qty >= buyX,
            do: qty - div(qty, buyX) * getY,
            else: qty
          )

        acc |> Map.put(product_code, newQty)
      else
        acc |> Map.put(product_code, qty)
      end
    end)
  end
end
