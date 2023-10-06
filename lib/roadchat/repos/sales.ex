defmodule Roadchat.Repos.Sales do
  import Ecto.Query, warn: false
  alias Roadchat.Repo
  alias Roadchat.Schemas.Sale

  def build_sale(attrs \\ %{}) do
    %Sale{}
    |> Sale.blank_changeset(attrs)
  end


  def create_sale(attrs \\ %{}) do
    IO.puts "inside repo: create post"
    %Sale{}
    |> Sale.changeset(attrs)
    |> Repo.insert()
  end

  # get single post
  def get_sale!(id), do: Repo.get!(Sale, id)

  # get posts
  def list_sales do
    Repo.all(Sale)
  end


  def update_sale(%Sale{} = sale, attrs) do
    sale
    |> Sale.blank_changeset(attrs)
    |> Repo.update()
  end


end
