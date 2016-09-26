defmodule RedmartClient do
  use HTTPoison.Base

  def start(:normal, []) do
    Agent.start_link(fn -> "" end, name: :session_id)
  end

  def login(email, password) do
    request_body = %{ "email": email, "password": password } |> Poison.encode!
    case RedmartClient.post("/members/login", request_body) do
      {:ok, %{headers: headers}} ->
        store_cookie(headers)
        :ok
      {:error, resp} ->
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

  # def add_item(item_id, qty) do
  #   request_body = %{
  #     "session": session_id,
  #     "id": item_id,
  #     "qty": qty,
  #     # "qty_in_stock": 761,
  #     # "discrepancy": false,
  #     # "trackingPrefix": "miniShelf"
  #   }
  #   case RedmartClient.put!("/cart/11111", request_body) do
  #     response = %{status_code: 200} ->
  #       IO.puts "Add Item successful"
  #       IO.puts "Response = #{inspect(response)}"
  #       :ok
  #     response ->
  #       IO.puts "Add Item failed"
  #       IO.puts "Response = #{inspect(response)}"
  #       :error
  #   end
  # end

  def cart() do
    case RedmartClient.get!("/cart?session=#{session_id}") do
      response = %{body: body, status_code: 200} ->
        {:ok, body}
      response ->
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
