defmodule Roadchat.Repo.Migrations.CreateLoggedinUsersTable do
  use Ecto.Migration

  def change do
    create table(:loggedin_users) do
      add :user_id, :int, null: false
      add :logged_in, :boolean
      timestamps(type: :timestamptz)
    end
  end
end
