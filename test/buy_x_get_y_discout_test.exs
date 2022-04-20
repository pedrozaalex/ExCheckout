defmodule BuyXGetYDiscountTest do
  use ExUnit.Case
  doctest BuyXGetYDiscount

  test "applies buy X get Y discounts" do
    discounts = %{"VOUCHER" => %{"buy" => 2, "get" => 1}}

    cart = [
      %Product{id: "VOUCHER", name: "Voucher", price: 5.0},
      %Product{id: "VOUCHER", name: "Voucher", price: 5.0},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
      %Product{id: "VOUCHER", name: "Voucher", price: 5.0}
    ]

    expected = [
      %Product{id: "VOUCHER", name: "Voucher", price: 0.0},
      %Product{id: "VOUCHER", name: "Voucher", price: 5.0},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
      %Product{id: "VOUCHER", name: "Voucher", price: 5.0}
    ]

    assert BuyXGetYDiscount.apply_discounts(cart, discounts) == expected

    cart = [
      %Product{id: "VOUCHER", name: "Voucher", price: 5.0},
      %Product{id: "VOUCHER", name: "Voucher", price: 5.0},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
      %Product{id: "VOUCHER", name: "Voucher", price: 5.0},
      %Product{id: "VOUCHER", name: "Voucher", price: 5.0}
    ]

    expected = [
      %Product{id: "VOUCHER", name: "Voucher", price: 0.0},
      %Product{id: "VOUCHER", name: "Voucher", price: 0.0},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
      %Product{id: "VOUCHER", name: "Voucher", price: 5.0},
      %Product{id: "VOUCHER", name: "Voucher", price: 5.0}
    ]

    assert BuyXGetYDiscount.apply_discounts(cart, discounts) == expected
  end
end
