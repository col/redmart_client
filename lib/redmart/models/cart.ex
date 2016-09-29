defmodule Redmart.Models.Cart do
  alias Redmart.Models.{Cart, CartGroup, CartTotals, Product}

  defstruct [
    id: 0,
    items: [ %Product{} ],
    groups: [ %CartGroup{} ],
    state: 0,
    total: %CartTotals{}
  ]

  def new(data) do
    Poison.decode!(Poison.encode!(data), as: %Cart{})
  end

end
