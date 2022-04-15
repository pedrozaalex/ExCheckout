defmodule BulkDiscount do
  defstruct min: 0, bulkPrice: 0.0

  def get_all_from_config() do
    ProductsConfig.get_config()
    |> Map.get("discounts")
    |> Map.get("bulk")
  end
end
