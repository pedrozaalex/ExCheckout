defmodule BulkDiscountTest do
  use ExUnit.Case
  doctest BulkDiscount

  test "applies bulk discounts" do
    discounts = %{"TSHIRT" => %{"bulkPrice" => 19.0, "min" => 3}}

    cart = [
      %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0}
    ]

    expected = [
      %Product{id: "TSHIRT", name: "T-Shirt", price: 19.0},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 19.0},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 19.0},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 19.0}
    ]

    assert BulkDiscount.apply_discounts(cart, discounts) == expected
  end
end
