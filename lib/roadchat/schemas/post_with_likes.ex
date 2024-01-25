defmodule Roadchat.Schemas.PostWithLikes do
  use Ecto.Schema
  # alias Roadchat.Schemas.PostWithLikes

  @derive {Jason.Encoder, only: [
      :user_id,
      :post_img,
      :comment_count,
      :like_count,
      :avatar,
      :user_liked_post,
      :first_name,
      :last_name
      ]}

  embedded_schema  do
    field :post, :string
    field :post_img, :string
    field :avatar, :string
    field :user_id, :integer
    field :user_liked_post, :boolean
    field :comment_count, :integer
    field :like_count, :integer
    field :first_name, :string
    field :last_name, :string
  end
end
