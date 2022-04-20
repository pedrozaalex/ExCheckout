defmodule CheckoutTest do
  use ExUnit.Case
  doctest Checkout

  test "calculates total" do
    buy_X_get_Y_discounts = %{"VOUCHER" => %{"buy" => 2, "get" => 1}}
    bulk_discounts = %{"TSHIRT" => %{"bulkPrice" => 19.0, "min" => 3}}

    combos = [
      %{
        "id" => "MUG+TSHIRT",
        "name" => "Mug + 2x T-shirt combo",
        "items" => %{"TSHIRT" => 2, "MUG" => 1},
        "price" => 10.0
      }
    ]

    calculate_total = &Checkout.calculate_total(&1, bulk_discounts, buy_X_get_Y_discounts, combos)

    assert calculate_total.([
             %Product{id: "VOUCHER", name: "Voucher", price: 5.0},
             %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
             %{Productid: "MUG", name: "Coffee Mug", price: 7.5}
           ]) == 32.50

    assert calculate_total.([
             %Product{id: "VOUCHER", name: "Voucher", price: 5.0},
             %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
             %Product{id: "VOUCHER", name: "Voucher", price: 5.0}
           ]) == 25.00

    assert calculate_total.([
             %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
             %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
             %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
             %Product{id: "VOUCHER", name: "Voucher", price: 5.0},
             %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0}
           ]) == 81.00

    assert calculate_total.([
             %Product{id: "VOUCHER", name: "Voucher", price: 5.0},
             %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
             %Product{id: "VOUCHER", name: "Voucher", price: 5.0},
             %Product{id: "VOUCHER", name: "Voucher", price: 5.0},
             %{Productid: "MUG", name: "Coffee Mug", price: 7.5},
             %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
             %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0}
           ]) == 74.50
  end
end
