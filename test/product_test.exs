defmodule ProductTest do
  use ExUnit.Case
  doctest Product

  test "is_valid? returns false for invalid products" do
    assert Product.is_valid?(nil) == false
    assert Product.is_valid?(1) == false
    assert Product.is_valid?(1.0) == false
    assert Product.is_valid?("") == false
    assert Product.is_valid?(true) == false
    assert Product.is_valid?(false) == false
    assert Product.is_valid?([1, 2, 3]) == false
    assert Product.is_valid?([1, 2, 3.0]) == false
    assert Product.is_valid?({}) == false
  end

  test "is_valid? returns true for valid products" do
    assert Product.is_valid?(%{id: "1", name: "", price: 0.0}) == true
  end

  test "print returns nil for invalid products" do
    assert Product.print(nil) == nil
    assert Product.print(1) == nil
    assert Product.print(1.0) == nil
    assert Product.print("") == nil
    assert Product.print(true) == nil
    assert Product.print(false) == nil
    assert Product.print([1, 2, 3]) == nil
    assert Product.print([1, 2, 3.0]) == nil
    assert Product.print({}) == nil
  end

  test "print returns string for valid products" do
    str = Product.print(%{id: "", name: "Test Product", price: 123.4})

    assert String.contains?(str, "Test Product")
    assert String.contains?(str, "123.4")
  end

  test "catalog_to_string prints all products" do
    str1 = Product.catalog_to_string([%{id: "1", name: "", price: 1.0}])
    assert String.contains?(str1, "1")
    assert String.contains?(str1, "1.0")

    str2 =
      Product.catalog_to_string([
        %{id: "", name: "Product 1", price: 5.0},
        %{id: "", name: "Product 2", price: 10.0}
      ])

    assert String.contains?(str2, "Product 1")
    assert String.contains?(str2, "5.0")

    assert String.contains?(str2, "Product 2")
    assert String.contains?(str2, "10.0")
  end
end
