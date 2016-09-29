defmodule Redmart.ClientTest do
  use ExUnit.Case
  alias Redmart.Client
  alias Redmart.Models.{Cart, SearchResult}
  doctest Redmart.Client

  @email Application.get_env(:redmart_client, :email)
  @password Application.get_env(:redmart_client, :password)

  setup tags do
    Client.start(:normal, [])
    if tags[:logged_in] do
      Client.login(@email, @password)
      assert Client.logged_in?
    end
    :ok
  end

  test "successful login" do
    Client.login(@email, @password)
    assert Client.logged_in?
  end

  test "failed login" do
    Client.login("nobody@gmail.com", "password")
    refute Client.logged_in?
  end

  @tag :logged_in
  test "logout" do
    Client.logout
    refute Client.logged_in?
  end

  @tag :logged_in
  test "cart" do
    {:ok, cart} = Client.cart
    assert cart.__struct__ == Cart
  end

  @tag :logged_in
  test "search" do
    {:ok, result} = Client.search("Pura Fresh Milk")
    assert result.__struct__ == SearchResult
  end

  @tag :logged_in
  test "add item to cart" do
    milk_id = Application.get_env(:redmart_client, :milk_product_id)
    assert {:ok, response} = Client.add_item(milk_id, 1)    
  end

end
