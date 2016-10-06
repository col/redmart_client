defmodule Redmart.ClientTest do
  use ExUnit.Case
  alias Redmart.Client
  alias Redmart.Models.{Cart, SearchResult}
  doctest Redmart.Client

  @email Application.get_env(:redmart_client, :email)
  @password Application.get_env(:redmart_client, :password)

  setup tags do
    if tags[:logged_in] do
      {:ok, session_id} = Client.login(@email, @password)
      assert Client.logged_in?(session_id)
      {:ok, session_id: session_id}
    else
      :ok
    end
  end

  test "successful login" do
    {:ok, session_id} = Client.login(@email, @password)
    assert Client.logged_in?(session_id)
  end

  test "failed login" do
    assert :error = Client.login("nobody@gmail.com", "password")
  end

  @tag :logged_in
  test "cart", %{session_id: session_id} do
    {:ok, cart} = Client.cart(session_id)
    assert cart.__struct__ == Cart
  end

  @tag :logged_in
  test "search", %{session_id: session_id} do
    {:ok, result} = Client.search(session_id, "Pura Fresh Milk")
    assert result.__struct__ == SearchResult
  end

  @tag :logged_in
  test "add item to cart", %{session_id: session_id} do
    milk_id = Application.get_env(:redmart_client, :milk_product_id)
    assert {:ok, _response} = Client.add_item(session_id, milk_id, 1)
  end

end
