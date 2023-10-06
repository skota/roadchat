defmodule RoadchatWeb.API.V1.LikeController do
  use RoadchatWeb, :controller

  alias Ecto.Changeset
  alias Plug.Conn


  def index(conn, _params) do
    conn
    |> put_status(200)
    |> json(%{ok: %{code: 200, message: "You are in like controller"}})
  end

  # like post

  # unlike post
end
