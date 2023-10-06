defmodule Roadchat.Repo.Migrations.CreateCommentsTable do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :post_id, :integer, null: false
      add :user_id, :integer, null: false
      add :comment, :text, null: false
      add :avatar, :string, null: true
      timestamps()
    end
  end
end
