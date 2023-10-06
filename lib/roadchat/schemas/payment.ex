defmodule Roadchat.Schemas.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    field :sale_id, :integer
    field :user_id, :integer
    field :amount, :integer
    field :paymentintent_id, :string
    field :payment_method_id, :string
    field :settled, :boolean
    timestamps(type: :utc_datetime)
  end

  @cast_fields [
              :sale_id,
              :user_id,
              :amount,
              :paymentintent_id,
              :payment_method_id,
              :settled
              ]

  @required_fields [
        :sale_id,
        :user_id,
        :amount,
        :paymentintent_id,
        :settled
      ]
  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end
end
