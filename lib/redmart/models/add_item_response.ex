defmodule Redmart.Models.AddItemResponse do
  alias Redmart.Models.{AddItemResponse, Cart, Product, Status, CartTotals}

  defstruct [status: %Status{}, item: %Product{}, cart: %Cart{}, total: %CartTotals{}]

  def new(data) do
    Poison.decode!(Poison.encode!(data), as: %AddItemResponse{})
  end

end
