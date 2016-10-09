defmodule Redmart.Models.CartGroup do
  alias Redmart.Models.{CartGroup, Product}

  defstruct [id: 0, items: [ %Product{} ]]

  def new(data) do
    Poison.decode!(Poison.encode!(data), as: %CartGroup{})
  end

end
