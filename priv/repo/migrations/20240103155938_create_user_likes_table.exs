defmodule Roadchat.Repo.Migrations.CreateUserLikesTable do
  use Ecto.Migration

  def change do
    create table(:user_likes) do
      add :user_id, :int, null: false
      add :post_id, :int, null: false
      timestamps(type: :timestamptz)
    end
  end
end
