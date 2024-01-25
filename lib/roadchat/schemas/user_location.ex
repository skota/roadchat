defmodule Roadchat.Schemas.UserLocation do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Roadchat.Schemas.UserLocation

  @derive {Jason.Encoder, only: [:id, :user_id, :geom, :inserted_at]}

  @required_fields [
    :user_id,
    :geom,
    :inserted_at
  ]
  @cast_fields [
    :geom,
    :user_id,
    :inserted_at
  ]

  schema "user_location" do
    field :user_id, :integer
    field :geom, Geo.PostGIS.Geometry
    field :inserted_at, :naive_datetime
  end

  def changeset(%UserLocation{} = location, attrs) do
    location
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end
end
