defmodule Roadchat.Repos.CustomerCards do
  import Ecto.Query, warn: false
  alias Roadchat.Repo

  alias Roadchat.Schemas.CustomerCard

  # get by id
  def get_card!(id), do: Repo.get!(CustomerCard, id)


  def get_card_by_user(id), do: Repo.get_by(CustomerCard, [user_id: id])


  #  create new
  def create_card(attrs \\ %{}) do
    %CustomerCard{}
    |> CustomerCard.changeset(attrs)
    |> Repo.insert!()
  end

  #  delete
  # def delete_runner(%Runner{} = runner) do
  #   Repo.delete(runner)
  # end
end
