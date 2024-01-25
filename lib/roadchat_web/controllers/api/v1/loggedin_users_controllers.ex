defmodule RoadchatWeb.API.V1.LoggedinUsersController do
  use RoadchatWeb, :controller
  # alias Ecto.Changeset
  # alias Plug.Conn
  alias Roadchat.Repos.LoggedinUsers

  def is_token_valid(conn, _params) do

    # call guardian jwt verify
    # %{"typ" => "access"}

    # case Roadchat.Guardian.decode_and_verify()


    conn
    |> put_status(200)
    |> json(%{ok: "use is logged in. Token valid"})
  end

  def get_users_in_range(conn, %{"id" => id}) do
    userid = String.to_integer(id)
    result = LoggedinUsers.get_users_in_range(userid)
    data_list = LoggedinUsers.sql_magic(result)

    conn
    |> put_status(200)
    |> json(data_list)
  end

  # user logged in
  def user_logged_in(conn, %{"user" => user_params}) do
    IO.puts "inside user_logged_in"
    IO.inspect user_params
    case LoggedinUsers.get_loggedin_user(user_params["id"]) do
      nil ->
        geo = %Geo.Point{coordinates: {user_params["lon"], user_params["lat"]}, srid: 4326}
        LoggedinUsers.create_loggedin_user(%{user_id: user_params["id"],
                  logged_in: true, current_position: geo })
      user ->
        LoggedinUsers.update_loggedin_user(user, %{logged_in: true})
      end

      conn
      |> put_status(200)
      |> json(%{ok: "logged in"})
  end


  # user is logged in
  @spec user_logged_out(Plug.Conn.t(), map) :: Plug.Conn.t()
  def user_logged_out(conn, %{"user" => user_params}) do
    # userid = user_params["id"]

    # get loggedin_user
    user = LoggedinUsers.get_loggedin_user(user_params["id"])
    # update loggedin_user
    LoggedinUsers.update_loggedin_user(user, %{logged_in: false})

    conn
    |> put_status(200)
    |> json(%{ok: "logged out"})
  end


  # def update geo position
  def update_geo_position(conn, %{"geo" => geo_params}) do
    IO.inspect geo_params

    user = LoggedinUsers.get_loggedin_user(geo_params["user_id"])
    geo = %Geo.Point{coordinates: {geo_params["lon"], geo_params["lat"]}, srid: 4326}

    IO.inspect geo
    # LoggedinUsers.update_loggedin_user(user, %{current_position: geo})

    # geo = %Geo.Point{coordinates: {user_params["lon"], user_params["lat"]}, srid: 4326}
    # LoggedinUsers.create_loggedin_user(%{user_id: 155,
    #           logged_in: true, current_position: geo })
    conn
    |> put_status(200)
    |> json(%{ok: "geo position updated"})
  end

end
