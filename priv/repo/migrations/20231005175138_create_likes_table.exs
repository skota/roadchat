defmodule Roadchat.Repo.Migrations.CreateLikesTable do
  use Ecto.Migration

  def change do
    create table(:likes) do
      add :user_id, :integer, null: false
      add :post_id, :integer, null: false
      add :like_count, :integer, null: false
      timestamps()
    end
  end
end
