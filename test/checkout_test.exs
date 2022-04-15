defmodule CheckoutTest do
  use ExUnit.Case
  doctest Checkout

  test "applies bulk discounts" do
    catalog = [
      %Product{id: "VOUCHER", name: "Voucher", price: 5.0},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
      %Product{id: "MUG", name: "Coffee Mug", price: 7.5}
    ]

    discounts = %{"TSHIRT" => %{"bulkPrice" => 19.0, "min" => 3}}

    cart = %{"MUG" => 0, "TSHIRT" => 4, "VOUCHER" => 0}

    assert Checkout.apply_bulk_discounts(cart, catalog, discounts) == 4 * 19.0
  end

  test "applies buy X get Y discounts" do
    discounts = %{"TSHIRT" => %{"buy" => 3, "get" => 1}}

    cart = %{"MUG" => 0, "TSHIRT" => 4, "VOUCHER" => 0}

    assert Checkout.apply_buy_X_get_Y_discounts(cart, discounts) == %{
             "MUG" => 0,
             "TSHIRT" => 3,
             "VOUCHER" => 0
           }
  end

  test "calculates total" do
    catalog = [
      %Product{id: "VOUCHER", name: "Voucher", price: 5.0},
      %Product{id: "TSHIRT", name: "T-Shirt", price: 20.0},
      %Product{id: "MUG", name: "Coffee Mug", price: 7.5}
    ]

    buy_X_get_Y_discounts = %{"VOUCHER" => %{"buy" => 2, "get" => 1}}

    bulk_discounts = %{"TSHIRT" => %{"bulkPrice" => 19.0, "min" => 3}}

    assert Checkout.calculate_total(
             ["VOUCHER", "TSHIRT", "MUG"],
             catalog,
             bulk_discounts,
             buy_X_get_Y_discounts
           ) == 32.50

    assert Checkout.calculate_total(
             ["VOUCHER", "TSHIRT", "VOUCHER"],
             catalog,
             bulk_discounts,
             buy_X_get_Y_discounts
           ) == 25.00

    assert Checkout.calculate_total(
             ["TSHIRT", "TSHIRT", "TSHIRT", "VOUCHER", "TSHIRT"],
             catalog,
             bulk_discounts,
             buy_X_get_Y_discounts
           ) == 81.00

    assert Checkout.calculate_total(
             [
               "VOUCHER",
               "TSHIRT",
               "VOUCHER",
               "VOUCHER",
               "MUG",
               "TSHIRT",
               "TSHIRT"
             ],
             catalog,
             bulk_discounts,
             buy_X_get_Y_discounts
           ) == 74.50
  end
end
