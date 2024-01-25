defmodule Roadchat.Schemas.RecentChat do
  use Ecto.Schema
  import Ecto.Changeset

  alias Roadchat.Schemas.RecentChat

  @derive {Jason.Encoder, only: [:id, :user_id, :chat_with_user_id, :last_message, :last_message_datetime]}

  @required_fields [
    :chat_with_user_id,
    :user_id,
    :last_message,
    :last_message_datetime
  ]
  @cast_fields [
    :chat_with_user_id,
    :user_id,
    :last_message,
    :last_message_datetime
  ]

  schema "recent_chats" do
    field :user_id, :integer
    field :chat_with_user_id, :integer
    field :last_message, :string
    field :last_message_datetime, :naive_datetime
    timestamps(type: :utc_datetime)
  end

  def changeset(%RecentChat{} = chat, attrs) do
    chat
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end
end
