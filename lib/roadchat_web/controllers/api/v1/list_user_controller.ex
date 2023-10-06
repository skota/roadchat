defmodule RoadchatWeb.API.V1.ListUserController do
  use RoadchatWeb, :controller

  alias Roadchat.Repo
  alias Roadchat.Accounts.User
  import Ecto.Query


  def index(conn, %{"id" => id}) do
    users =from(u in User, where: u.id != ^id) |> Repo.all()
    # render(conn, "index.json", users: users)

    conn = conn |> put_status(200)
    json(conn, %{users: users})


  end

  # like post

  # unlike post
end
