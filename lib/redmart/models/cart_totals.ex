defmodule Redmart.Models.CartTotals do
  alias Redmart.Models.CartTotals

  defstruct [
    sub_total: 0,
    shipping: 0,
    grand_total: 0,
    dollars_to_free_delivery: 0
  ]

  def new(data) do
    Poison.decode!(Poison.encode!(data), as: %CartTotals{})
  end

end
