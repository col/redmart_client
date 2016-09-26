defmodule Redmart.Models.Cart do
  alias Redmart.Models.Cart

  defstruct [id: 0, items: [], member_order_count: 0, state: 0, total: %{}]

  def new(data) do
    Poison.decode!(Poison.encode!(data), as: %Cart{})
  end

end
