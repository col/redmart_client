defmodule Redmart.Models.SearchResultTest do
  use ExUnit.Case
  alias Redmart.Models.Product
  alias Redmart.Models.SearchResult

  @example_data %{
    "products" => [ %{ "id": 2, "title": "sample product" } ],
    "total" => 10,
    "page" => 1,
    "page_size" => 10
  }

  @expected %SearchResult{
    products: [ %Product{id: 2, title: "sample product"} ],
    total: 10,
    page: 1,
    page_size: 10
  }

  test "create with json" do
     search_result = Poison.decode!(Poison.encode!(@example_data), as: %SearchResult{})
     assert search_result == @expected
  end

  test "create with map" do
     search_result = SearchResult.new(@example_data)
     assert search_result == @expected
  end

end
