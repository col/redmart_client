defmodule Redmart.Models.CartTest do
  use ExUnit.Case
  alias Redmart.Models.{Cart, CartGroup, CartTotals, Product}

  @example_data %{
    "id" => 1,
    "items" => [],
    "groups" => [
      %{ "id" => 1, "items" => [ %{ "id" => 1, "title" => "Pura Milk", "qty" => 2 } ] }
    ],
    "member_order_count" => 2,
    "state" => 2,
    "total" => %{
      "sub_total" => 3.5,
      "shipping" => 7,
      "grand_total" => 10.5,
      "dollars_to_free_delivery" => 64.5
    }
  }

  @expected %Cart{
    id: 1,
    items: [],
    groups: [
      %CartGroup{ id: 1, items: [ %Product{id: 1, title: "Pura Milk", qty: 2} ] }
    ],
    state: 2,
    total: %CartTotals{
      sub_total: 3.5,
      shipping: 7,
      grand_total: 10.5,
      dollars_to_free_delivery: 64.5
    }
  }

  test "create with json" do
     cart = Poison.decode!(Poison.encode!(@example_data), as: %Cart{})
     assert cart == @expected
  end

  test "create with map" do
     cart = Cart.new(@example_data)
     assert cart == @expected
  end

end
