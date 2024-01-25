defmodule RoadchatWeb.API.V1.ChatController do
  use RoadchatWeb, :controller
  alias Roadchat.Repos.Chats

  # get user contacts with most recent chats ala whatsapp
  def index(conn, %{"id" => id}) do
    user_id = String.to_integer(id)
    contacts = Chats.get_user_chats(user_id)
      conn
      |> put_status(200)
      |> json(contacts)
  end

  # update last chat
  def update(conn, %{"message" => params}) do
    IO.inspect params
    case Chats.update_recent_chat(params) do
      {:ok, _chat} ->
        conn
        |> put_status(200)
        |> json(%{ok: "chat updated"})
      _ ->
        conn
        |> put_status(200)
        |> json(%{error: "UNable to update chat"})
    end


  end

end
