defmodule Redmart.Models.Status do
  alias Redmart.Models.Status

  defstruct [msg: "", code: 0]

  def new(data) do
    Poison.decode!(Poison.encode!(data), as: %Status{})
  end

end
