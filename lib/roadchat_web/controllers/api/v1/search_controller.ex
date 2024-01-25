defmodule RoadchatWeb.API.V1.SearchController do
  use RoadchatWeb, :controller
  alias Roadchat.Accounts

  def index(conn, %{"search_term" => search_term}) do
    users = Accounts.search_users(search_term)
    conn = conn
          |> put_status(200)
          json(conn, users)
  end
end
