defmodule Checkout do
  @moduledoc """
  Checkout module.
  """

  @doc """
  Entry point for checkout.
  """
  def start() do
    products = Product.get_all_from_config()

    bulks = BulkDiscount.get_all_from_config()
    buy_X_get_Y = BuyXGetYDiscount.get_all_from_config()
    combos = ComboDiscount.get_all_from_config()

    total =
      prompt_for_cart_products(products, [], :continue)
      |> calculate_total(bulks, buy_X_get_Y, combos)

    IO.puts("Total: #{total}€\n")
    {:ok, self()}
  end

  @doc """
  Creates a prompt for displaying cart products.
  """
  @spec get_products_selection_prompt([Product.t()], [String.t()]) :: String.t()
  def get_products_selection_prompt(catalog, cart) do
    "\n\nPlease select an item by entering it's number or a list of numbers separated by a space: \n\n" <>
      Product.catalog_to_string(catalog) <>
      "\n\n(0) Finish\n\n" <>
      "Products in cart: " <>
      (cart |> Enum.map(&Map.get(&1, :id)) |> Enum.join(", ")) <> "\n\nYour selection: "
  end

  @doc """
  Applies all existing discounts to the cart.
  """
  @spec apply_discounts(
          [Product.t()],
          %{optional(binary) => BulkDiscount},
          %{optional(binary) => BuyXGetYDiscount},
          [ComboDiscount]
        ) :: [Product.t()]
  def apply_discounts(cart, bulk, buy_X_get_Y, combo) do
    cart
    |> BulkDiscount.apply_discounts(bulk)
    |> BuyXGetYDiscount.apply_discounts(buy_X_get_Y)
    |> ComboDiscount.apply_discounts(combo)
  end

  @doc """
  Sums the price of all the items in the cart.
  """
  @spec sum_all_items_in_cart([Product.t()]) :: float()
  def sum_all_items_in_cart(cart) do
    cart
    |> Enum.reduce(0.0, &(&2 + (&1 |> Map.get(:price))))
  end

  @doc """
  Calculates the total price of the cart, including discounts.
  """
  @spec calculate_total(
          [Product.t()],
          %{optional(binary) => BulkDiscount},
          %{optional(binary) => BuyXGetYDiscount},
          [ComboDiscount]
        ) :: float
  def calculate_total(cart, bulk_discounts, buy_X_get_Y_discounts, combos) do
    cart
    |> apply_discounts(bulk_discounts, buy_X_get_Y_discounts, combos)
    |> sum_all_items_in_cart()
  end

  @doc """
  Fetch from the catalog a product by it's code, or nil if not found.
  """
  @spec get_product_by_index([Product.t()], String.t()) :: Product.t() | nil
  def get_product_by_index(catalog, index) do
    try do
      catalog
      |> List.to_tuple()
      |> elem(index - 1)
    rescue
      _ -> nil
    end
  end

  @doc """
  Given a list of indexes ([1, 2, 3, 1, 1, ...]) returns a list of products
  """
  @spec to_product_list([number()], [Product.t()]) :: [Product.t()]
  def to_product_list(index_list, catalog) do
    index_list
    |> Enum.map(&get_product_by_index(catalog, &1))
    |> Enum.filter(fn x -> x != %{} and not is_nil(x) end)
  end

  @spec filter_code_list([any()]) :: [number()]
  def filter_code_list(code_list) do
    code_list |> Enum.filter(&(is_integer(&1) && 0 < &1 && &1 <= length(&1)))
  end

  @doc """
  Prompts the user for which products to add to the cart.
  """
  @spec prompt_for_cart_products([Product.t()], [String.t()], :continue | :stop) :: any
  def prompt_for_cart_products(catalog, cart, :continue) do
    input = get_products_selection_prompt(catalog, cart) |> IO.gets() |> String.trim()

    # If the input contains multiple numbers, code_or_list will be a list
    code_or_list =
      if input |> Helpers.has_multiple_numbers?() do
        input
        |> String.split(" ")
        |> Enum.map(&Helpers.parse_int(&1))
      else
        # Otherwise, it will be a single code
        input |> String.first() |> Helpers.parse_int()
      end

    {new_cart, op} =
      cond do
        is_nil(code_or_list) ->
          IO.puts("Invalid input, please try again.")
          {cart, :stop}

        # 0 means finish
        code_or_list == 0 ->
          {cart, :stop}

        is_list(code_or_list) ->
          new_items =
            code_or_list
            |> Enum.filter(&(is_integer(&1) && 0 < &1 && &1 <= length(catalog)))
            |> Enum.map(&get_product_by_index(catalog, &1))
            |> Enum.filter(fn x -> x != %{} and not is_nil(x) end)

          {cart ++ new_items, :continue}

        true ->
          try do
            product = catalog |> List.to_tuple() |> elem(code_or_list - 1)

            new_cart = cart ++ [product]

            {new_cart, :continue}
          rescue
            _ ->
              IO.puts("Invalid selection\n")
              {cart, :continue}
          end
      end

    prompt_for_cart_products(catalog, new_cart, op)
  end

  def prompt_for_cart_products(_, cart, :stop), do: cart
end
