defmodule Roadchat.Schemas.Like do
  use Ecto.Schema
  import Ecto.Changeset

  alias Roadchat.Schemas.Like

  @derive {Jason.Encoder, only: [:post_id, :user_id, :like_count]}

  @required_fields [
    :post_id,
    :user_id,
    :like_count
  ]

  @cast_fields [
    :post_id,
    :user_id,
    :like_count
  ]

  schema "likes" do
    field :post_id, :string
    field :user_id, :integer
    field :like_count, :integer
    timestamps()
  end

  def changeset(%Like{} = like, attrs) do
    like
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end
end
