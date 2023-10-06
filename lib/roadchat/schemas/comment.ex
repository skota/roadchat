defmodule Roadchat.Schemas.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Roadchat.Schemas.Comment

  @required_fields [
    :post_id,
    :user_id,
    :comment,

  ]

  @cast_fields [
    :post_id,
    :user_id,
    :comment,
    :avatar
  ]

  schema "comments" do
    field :post_id, :integer
    field :user_id, :integer
    field :comment, :string
    field :avatar, :string
    timestamps(type: :utc_datetime)
  end

  def blank_changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, @cast_fields)
  end

  # def update_changeset(%Patient{} = patient, attrs) do
  #   patient
  #   |> cast(attrs, @cast_fields)
  #   # |> validate_required(@update_fields)
  # end

  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end
end
