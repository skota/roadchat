defmodule RoadchatWeb.Api.V1.UserSessionController do
  use RoadchatWeb, :controller

  alias Roadchat.{Accounts, Guardian, Settings}
  alias RoadchatWeb.UserAuth
  alias Roadchat.Servers.UserStateServer
  # alias Roadchat.Repos.CustomerCards


  def create(conn, %{"user" => %{"email" => "", "password" => ""}}) do
    conn
    |> put_status(401)

    json(conn, %{error: "Email or Password is blank"})
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        conn =
          conn
          |> put_status(401)

        json(conn, %{error: "User could not be authenticated"})

      user ->
        conn =
          conn
          |> put_status(201)

        # store user id in genseever
        UserStateServer.add_user(user.id)
        settings = []
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, %{})

        json(conn, %{
          user: user,
          jwt: jwt,
          settings: settings,
        })
    end
  end

  def delete(conn, _params) do
    conn
    |> UserAuth.log_out_user()
  end
end
