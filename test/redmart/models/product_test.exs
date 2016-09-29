defmodule Redmart.Models.ProductTest do
  use ExUnit.Case
  alias Redmart.Models.Product

  @example_data %{
    "id" => 1,
    "title" => "Little Creatures Pale Ale",
    "qty" => 2
  }

  @expected %Product{
    id: 1,
    title: "Little Creatures Pale Ale",
    qty: 2
  }

  test "create with json" do
     product = Poison.decode!(Poison.encode!(@example_data), as: %Product{})
     assert product == @expected
  end

  test "create with map" do
     product = Product.new(@example_data)
     assert product == @expected
  end

end
