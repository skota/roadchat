defmodule Roadchat.Repo.Migrations.CreateCustomerCardsTable do
  use Ecto.Migration

  def change do
    create table(:customer_cards) do
      add :user_id, :int, null: false
      add :payment_method_id, :string, null: false
      add :card_type, :string, null: false
      add :card_last_4, :string, null: false
      add :expiry_month, :string, null: false
      add :expiry_year, :string, null: false
      timestamps(type: :timestamptz)
    end

  end
end
