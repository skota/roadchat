defmodule Roadchat.Repos.Payments do

  import Ecto.Query, warn: false
  alias Roadchat.Repo
  alias Roadchat.Schemas.Payment

  def create_payment(attrs \\ %{}) do
    # IO.inspect attrs
    %Payment{}
    |> Payment.changeset(attrs)
    |> Repo.insert!()
  end
end
