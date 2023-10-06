defmodule Roadchat.Repo.Migrations.CreatePaymentsTable do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :sale_id, :int, null: false
      add :user_id, :int, null: false
      add :amount, :int, null: false
      add :paymentintent_id, :string, null: false
      add :payment_method_id, :string
      add :settled, :boolean, default: false
      timestamps(type: :timestamptz)
    end
  end
end
