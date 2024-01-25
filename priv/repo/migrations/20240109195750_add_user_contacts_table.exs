defmodule Roadchat.Repo.Migrations.AddUserContactsTable do
  use Ecto.Migration

  # This table stores a user <-> contact relationship
  # there will be two rows per connection between users a and b

  def change do
    create table(:user_contacts) do
      add :user_id, :int, null: false
      add :contact_with_user_id, :int, null: false
    end
  end
end
