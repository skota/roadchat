defmodule RoadchatWeb.API.V1.ContactController do
  use RoadchatWeb, :controller
  alias Roadchat.Accounts
  alias Roadchat.Schemas.RecentChat


  def create(conn, %{"contact" => params}) do
    user_id = params["user_id"]
    contact_with_user_id = params["contact_with_user_id"]
    # 1 - insert contacts
    users = [
      %{user_id: user_id, contact_with_user_id: contact_with_user_id},
      %{user_id: contact_with_user_id, contact_with_user_id: user_id}
    ]

    # 2 - recent chat
    dtt = DateTime.utc_now()
    DateTime.truncate(dtt, :second)

    chats = [%{
          last_message: "start chat now",
          user_id: user_id,
          chat_with_user_id: contact_with_user_id,
          last_message_datetime: NaiveDateTime.local_now(),
          inserted_at: DateTime.truncate(dtt, :second),
          updated_at: DateTime.truncate(dtt, :second)
        },
        %{
          last_message: "start chat now",
          user_id: contact_with_user_id,
          chat_with_user_id: user_id,
          last_message_datetime: NaiveDateTime.local_now(),
          inserted_at: DateTime.truncate(dtt, :second),
          updated_at: DateTime.truncate(dtt, :second)
        }
      ]

    with {:create_user_contacts, {_, nil}} = {:create_user_contacts, Accounts.add_user_contacts_multi(users)},
         {:insert_recent_chat, {_,  nil }} = {:insert_recent_chat, Accounts.insert_recent_chats_multi(chats)}  do
            conn
            |> put_status(201)
            |> json(%{message: "chat contact and recent chat added."})
    else
      {:create_user_contacts, _} ->
          conn
          |> put_status(200)
          |> json(%{error: "unable to create user contact"})
      {:insert_recent_chat, _} ->
          conn
          |> put_status(200)
          |> json(%{error: "unable to insert recent chat"})
    end
  end

end
