defmodule Helpers do
  @moduledoc """
  Helper functions.
  """

  def atom_keys(map) do
    for {key, val} <- map, into: %{} do
      {String.to_atom(key), val}
    end
  end

  @doc """
  Parses a string to an integer, returning nil if the string is not a number.
  """
  @spec parse_int(String.t()) :: integer() | nil
  def parse_int(str) do
    try do
      case Integer.parse(str) do
        {int, _remainder} ->
          int

        _ ->
          nil
      end
    rescue
      _ -> nil
    end
  end

  @doc """
  Counts how many items with a given code are in a list of products.
  """
  def count_item_in_cart(cart, code) do
    cart
    |> Enum.reduce(0, fn product, acc ->
      if code == product |> Map.get(:id), do: acc + 1, else: acc
    end)
  end

  @doc """
  Checks if a given input is a single code or a list of codes.
  """
  @spec has_multiple_numbers?(String.t()) :: boolean()
  def has_multiple_numbers?(input) do
    input =~ ~r/^(\d\s\d)+/
  end

  @doc """
  Removes an item from a list of products up to a given quantity of times.
  """
  @spec remove_item_from_cart([Product.t()], String.t(), number()) :: [Product.t()]
  def remove_item_from_cart(cart, product_code, qty \\ 1) do
    if qty >= 1 do
      product = cart |> Enum.find(fn p -> p.id == product_code end)
      newCart = cart |> List.delete(product)
      remove_item_from_cart(newCart, product_code, qty - 1)
    else
      cart
    end
  end

  @doc """
  Applies the given change function to n items in the list of products.
  """
  @spec update_n_cart_items(
          [Product.t()],
          number(),
          String.t(),
          fun :: (Product.t() -> Product.t())
        ) :: [Product.t()]
  def update_n_cart_items([], _, _, _) do
    []
  end

  def update_n_cart_items(cart, n, _, _) when n <= 0 do
    cart
  end

  def update_n_cart_items(cart, n, code, change) do
    index = cart |> Enum.find_index(fn i -> i |> Map.get(:id) == code end)

    new_cart =
      cart
      |> List.update_at(index, change)

    head = new_cart |> Enum.slice(0, index + 1)
    tail = new_cart |> Enum.slice(index + 1, length(new_cart))

    head ++
      update_n_cart_items(
        tail,
        n - 1,
        code,
        change
      )
  end
end
