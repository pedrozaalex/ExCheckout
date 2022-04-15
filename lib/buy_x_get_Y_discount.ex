defmodule BuyXGetYDiscount do
  defstruct buy: 0, get: 0

  def get_all_from_config() do
    ProductsConfig.get_config()
    |> Map.get("discounts")
    |> Map.get("buyXgetY")
  end
end
