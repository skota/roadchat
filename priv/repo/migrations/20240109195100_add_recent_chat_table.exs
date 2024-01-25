defmodule Roadchat.Repo.Migrations.AddRecentChatTable do
  use Ecto.Migration

  # this table stores the most recent chat message and datime
  def change do
    create table(:recent_chats) do
      add :user_id, :int, null: false
      add :chat_with_user_id, :int, null: false
      add :last_message, :string
      add :last_message_datetime, :naive_datetime
      timestamps(type: :timestamptz)
    end
  end
end
