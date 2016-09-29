defmodule Redmart.Models.Product do
  alias Redmart.Models.Product

  defstruct [id: 0, title: "", qty: 0]

  def new(data) do
    Poison.decode!(Poison.encode!(data), as: %Product{})
  end

end
