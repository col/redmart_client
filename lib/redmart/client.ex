defmodule Redmart.Client do
  use HTTPoison.Base
  alias Redmart.Client
  alias Redmart.Models.{Cart, SearchResult, AddItemResponse}

  @apiConsumerId "55a87a41-6c5b-4f51-b283-651ac6ede647"

  def start(:normal, []) do
    Agent.start_link(fn -> "" end, name: :session_id)
  end

  def login(email, password) do
    request_body = %{ "email": email, "password": password } |> Poison.encode!
    case Client.post("/members/login", request_body) do
      {:ok, %{headers: headers}} ->
        store_cookie(headers)
        :ok
      {:error, _} ->
        :error
    end
  end

  def logout do
    Agent.update(:session_id, fn(_) -> "" end)
    :ok
  end

  def logged_in? do
    session_id != ""
  end

  def add_item(item_id, qty) do
    request_body = %{
      "session" => session_id,
      "id" => item_id,
      "qty" => qty,
      "apiConsumerId" => @apiConsumerId
    }
    query = %{
      "session" => session_id,
      "apiConsumerId" => @apiConsumerId
    }
    case Client.put!("/cart/#{item_id}?#{URI.encode_query(query)}", Poison.encode!(request_body)) do
      %{body: body, status_code: 200} ->
        {:ok, AddItemResponse.new(body)}
      _ ->
        {:error, "request failed"}
    end
  end

  def cart() do
    query = %{
      "session" => session_id,
      "apiConsumerId" => @apiConsumerId
    }
    case Client.get!("/cart?#{URI.encode_query(query)}") do
      %{body: body, status_code: 200} ->
        {:ok, Cart.new(body["cart"])}
      _ ->
        {:error, "Request failed"}
    end
  end

  def search(search_term, page_size \\ 10, page \\ 0) do
    query = %{
      "q": search_term,
      "pageSize": page_size,
      "page": page,
      "sort": 1,
      "session": session_id
    }
    case Client.get!("/catalog/search?#{URI.encode_query(query)}") do
      %{body: body, status_code: 200} ->
        {:ok, SearchResult.new(body)}
      _ ->
        {:error, "Request failed"}
    end
  end

  defp process_url(url) do
    "http://api.redmart.com/v1.5.6" <> url
  end

  defp process_response_body(body) do
    body |> Poison.decode!
  end

  defp process_request_headers(headers) do
    Map.merge(
      Enum.into(default_headers, %{}),
      Enum.into(headers, %{})
    ) |> Map.to_list
  end

  defp default_headers do
    [ "Content-Type": "application/json" ]
  end

  defp session_id do
    Agent.get(:session_id, &(&1))
  end

  defp store_cookie(headers) do
    Agent.update(:session_id, fn(_) -> find_session_id(headers) end)
  end

  def find_session_id(headers) do
    case Enum.filter(headers, fn(h) -> elem(h,0) == "x-access-token" end) |> List.first do
      nil -> ""
      header -> elem(header, 1)
    end
  end

end
