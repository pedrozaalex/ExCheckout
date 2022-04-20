defmodule HelpersTest do
  use ExUnit.Case
  doctest Helpers

  test "removes item from cart" do
    cart = [
      %Product{id: "MUG", name: "Coffee Mug", price: 7.5},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0}
    ]

    assert Helpers.remove_item_from_cart(cart, "TSHIRT") == [
             %Product{id: "MUG", name: "Coffee Mug", price: 7.5},
             %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0}
           ]

    cart2 = [
      %Product{id: "MUG", name: "Coffee Mug", price: 7.5},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0}
    ]

    assert Helpers.remove_item_from_cart(cart2, "TSHIRT", 2) == [
             %Product{id: "MUG", name: "Coffee Mug", price: 7.5}
           ]
  end
end
