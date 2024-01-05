defmodule RoadchatWeb.API.V1.ProfileController do
  use RoadchatWeb, :controller

  # alias RoadchatWeb.APIAuthPlug
  alias Plug.Conn
  alias Roadchat.Repo
  alias Roadchat.Accounts.User

  @spec update(Conn.t(), map()) :: Conn.t()
  def update(conn, %{"user" => user_params}) do


    { id, _} = Integer.parse(conn.params["id"])
    user = Repo.get(User, id)

    IO.puts "updating user"
    IO.inspect user

    User.profile_changeset(user, user_params)
    |> Repo.update()

    conn
    |> put_status(200)
    |> json(%{ok: "profile updated"})

  end

  def userdetails(conn, %{"id" => id}) do
    user = Repo.get!(User,id)
    conn
    |> put_status(200)
    |> json(%{
      id: user.id,
      email: user.email,
      fname: user.fname,
      lname: user.lname,
      avatar: user.avatar,
      fb_user_id: user.fb_user_id
    })

    # conn
    # |> APIAuthPlug.renew(config)
    # |> case do
    #   {conn, nil} ->
    #     conn
    #     |> put_status(401)
    #     |> json(%{error: %{status: 401, message: "Invalid token"}})

    #   {conn, _user} ->
    #     json(conn, %{data: %{access_token: conn.private.api_access_token, renewal_token: conn.private.api_renewal_token}})
    # end
  end


end
