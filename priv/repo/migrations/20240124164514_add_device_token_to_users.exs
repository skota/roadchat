defmodule Roadchat.Repo.Migrations.AddDeviceTokenToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :device_token, :string, null: true
    end
  end
end
