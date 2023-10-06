defmodule Roadchat.Repo.Migrations.AlterUsersAddFbCreds do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :fb_user_id, :string, null: true
      add :fb_password, :string, null: true
      add :stripe_cust_id, :string, null: true
    end
  end
end
