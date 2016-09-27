defmodule Redmart.Models.Product do
  alias Redmart.Models.Product

  defstruct [id: 0, title: ""]

  def new(data) do
    Poison.decode!(Poison.encode!(data), as: %Product{})
  end

end
