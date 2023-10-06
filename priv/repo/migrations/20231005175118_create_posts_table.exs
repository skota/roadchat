defmodule Roadchat.Repo.Migrations.CreatePostsTable do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :post, :string, null: false
      add :post_img, :string, null: true
      add :user_id, :integer, null: false
      add :comment_count, :integer, null: false, default: 0
      add :like_count, :integer, null: false, default: 0

      timestamps()
    end
  end
end
