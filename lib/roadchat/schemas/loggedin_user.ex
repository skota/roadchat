defmodule Roadchat.Schemas.LoggedinUser do
  use Ecto.Schema
  import Ecto.Changeset


  schema "loggedin_users" do
    field :user_id, :integer
    field :logged_in, :boolean
    field :current_position, Geo.PostGIS.Geometry
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(loggedin_user, attrs) do
    loggedin_user
    |> cast(attrs, [:user_id, :logged_in, :current_position])
  end

  def update_changeset(loggedin_user, attrs) do
    loggedin_user
    |> cast(attrs, [:logged_in])
  end
end
