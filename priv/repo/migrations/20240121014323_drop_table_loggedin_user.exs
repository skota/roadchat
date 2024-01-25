defmodule Roadchat.Repo.Migrations.DropTableLoggedinUser do
  use Ecto.Migration

  def up do
    drop table(:loggedin_users)
  end

  def down do
    create table(:loggedin_users) do
      add :user_id, :int, null: false
      add :logged_in, :boolean
      timestamps(type: :timestamptz)
    end
  end
end
