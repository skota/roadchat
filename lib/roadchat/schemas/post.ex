defmodule Roadchat.Schemas.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Roadchat.Schemas.Post

  @derive {Jason.Encoder, only: [:post, :user_id, :post_img, :comment_count, :like_count]}

  @required_fields [
    :post,
    :user_id,
  ]

  @cast_fields [
    :post,
    :user_id,
    :post_img,
    :comment_count,
    :like_count

  ]

  schema "posts" do
    field :post, :string
    field :user_id, :integer
    field :post_img, :string
    field :comment_count, :integer
    field :like_count, :integer
    timestamps(type: :utc_datetime)
  end

  def blank_changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, @cast_fields)
  end

  # def update_changeset(%Patient{} = patient, attrs) do
  #   patient
  #   |> cast(attrs, @cast_fields)
  #   # |> validate_required(@update_fields)
  # end

  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end

  def update_changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, @cast_fields)
  end
end
