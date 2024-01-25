defmodule Roadchat.Schemas.UserContact do
  use Ecto.Schema
  import Ecto.Changeset

  alias Roadchat.Schemas.UserContact

  @derive {Jason.Encoder, only: [:id, :user_id, :contact_with_user_id]}

  @required_fields [
    :contact_with_user_id,
    :user_id
  ]

  @cast_fields [
    :contact_with_user_id,
    :user_id
  ]

  schema "user_contacts" do
    field :contact_with_user_id, :integer
    field :user_id, :integer
  end

  def changeset(%UserContact{} = contact, attrs) do
    contact
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end


end
