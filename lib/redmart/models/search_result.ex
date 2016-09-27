defmodule Redmart.Models.SearchResult do
  alias Redmart.Models.{SearchResult, Product}

  defstruct [products: [%Product{}], total: 0, page: 0, page_size: 0]

  def new(data) do
    Poison.decode!(Poison.encode!(data), as: %SearchResult{})
  end

end
