defmodule Checkout.Application do
  use Application

  def start(_type, _args) do
    Checkout.start()
    {:ok, self()}
  end
end
