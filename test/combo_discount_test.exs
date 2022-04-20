defmodule ComboDiscountTest do
  use ExUnit.Case
  doctest ComboDiscount

  test "check if cart has a combo" do
    combo = %{
      "name" => "MUG+TSHIRT",
      "items" => %{
        "TSHIRT" => 2,
        "MUG" => 1
      },
      "price" => 10.0
    }

    cart = [
      %Product{id: "MUG", name: "Coffee Mug", price: 7.5},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0}
    ]

    assert ComboDiscount.check_if_cart_has_combo(cart, combo)
  end

  test "applies combo discounts" do
    combos = [
      %{
        "id" => "MUG+TSHIRT",
        "name" => "Mug + 2x T-shirt combo",
        "items" => %{
          "TSHIRT" => 2,
          "MUG" => 1
        },
        "price" => 10.0
      }
    ]

    cart = [
      %Product{id: "MUG", name: "Coffee Mug", price: 7.5},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0}
    ]

    return_value = [
      %{id: "MUG+TSHIRT", name: "Mug + 2x T-shirt combo", price: 10.0}
    ]

    assert ComboDiscount.apply_discounts(cart, combos) == return_value
  end
end
