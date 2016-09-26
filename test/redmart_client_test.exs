defmodule RedmartClientTest do
  use ExUnit.Case
  doctest RedmartClient

  @email Application.get_env(:redmart_client, :email)
  @password Application.get_env(:redmart_client, :password)

  setup tags do
    RedmartClient.start(:normal, [])
    if tags[:logged_in] do
      RedmartClient.login(@email, @password)
      assert RedmartClient.logged_in?
    end
    :ok
  end

  test "successful login" do
    RedmartClient.login(@email, @password)
    assert RedmartClient.logged_in?
  end

  test "failed login" do
    RedmartClient.login("nobody@gmail.com", "password")
    refute RedmartClient.logged_in?
  end

  @tag :logged_in
  test "logout" do
    RedmartClient.logout
    refute RedmartClient.logged_in?
  end

  @tag :logged_in
  test "cart" do
    {:ok, cart} = RedmartClient.cart
    assert cart["cart"]
  end

end
