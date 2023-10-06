defmodule Roadchat.Schemas.CustomerCard do
  use Ecto.Schema
  import Ecto.Changeset

  schema "customer_cards" do
    field :user_id, :integer
    field :payment_method_id, :string
    field :card_type, :string
    field :card_last_4, :string
    field :expiry_month, :string
    field :expiry_year, :string
    timestamps(type: :utc_datetime)
  end


  def changeset(card, attrs) do
    card
    |> cast(attrs, [:user_id, :payment_method_id, :card_type, :card_last_4, :expiry_month, :expiry_year])
    |> validate_required([:user_id, :payment_method_id, :card_type, :card_last_4, :expiry_month, :expiry_year])

  end
end
