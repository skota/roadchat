defmodule Roadchat.Schemas.UserLikes do
  use Ecto.Schema
  import Ecto.Changeset

  alias Roadchat.Schemas.UserLikes

  @derive {Jason.Encoder, only: [:id, :user_id, :post_id]}

  @required_fields [
    :post_id,
    :user_id
  ]
  @cast_fields [
    :post_id,
    :user_id
  ]

  schema "user_likes" do
    field :post_id, :integer
    field :user_id, :integer
    timestamps()
  end

  def changeset(%UserLikes{} = like, attrs) do
    like
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end


end
