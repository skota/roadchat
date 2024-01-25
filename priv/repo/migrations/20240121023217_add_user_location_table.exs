defmodule Roadchat.Repo.Migrations.AddUserLocationTable do
  use Ecto.Migration

  def change do
    create table(:user_location) do
      add :user_id, :int, null: false
      add :logged_in, :boolean
      add :geom,  :geometry
      add :inserted_at, :naive_datetime
    end
  end
end
