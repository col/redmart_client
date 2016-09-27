defmodule Redmart.Models.CartTest do
  use ExUnit.Case
  alias Redmart.Models.Cart

  @example_data %{
    "id" => 1,
    "items" => [],
    "member_order_count" => 2,
    "state" => 0,
    "total" => %{}
  }

  def assert_cart_matches_data(cart, data) do
    assert cart.id == data["id"]
    assert cart.items == data["items"]
    assert cart.member_order_count == data["member_order_count"]
    assert cart.state == data["state"]
    assert cart.total == data["total"]
  end

  test "create with json" do
     cart = Poison.decode!(Poison.encode!(@example_data), as: %Cart{})
     assert_cart_matches_data(cart, @example_data)
  end

  test "create with map" do
     cart = Cart.new(@example_data)
     assert_cart_matches_data(cart, @example_data)
  end

end
