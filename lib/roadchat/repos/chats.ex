# context for chats and user contacts
defmodule Roadchat.Repos.Chats do
  @moduledoc """
  The Chats context.
  """
  import Ecto.Query, warn: false
  alias Roadchat.Repo
  alias Roadchat.Schemas.RecentChat

  # alias Roadchat.Schemas.{UserContact, RecentChat}

  def get_user_contacts(user_id) do
    # join user_contacts and users
    # get contact name, email, avatar
    query = from c in "user_contacts",
            join: u in "users", on: c.contact_with_user_id == u.id,
            where: c.user_id == ^user_id,
            select: %{
              id: u.id,
              fname: u.fname,
              email: u.email,
              avatar: u.avatar
            }
     Repo.all(query)
  end

  def get_user_chats(user_id) do
    # join recent_chats and users
    # got get contact name, email, avatar, last-message and last message timestamp
    query = from c in "recent_chats",
            join: u in "users", on: c.chat_with_user_id == u.id,
            where: c.user_id == ^user_id,
            select: %{
              chat_with_user_id: u.id,
              fname: u.fname,
              email: u.email,
              avatar: u.avatar,
              last_message: c.last_message,
              last_message_datetime: c.last_message_datetime
            }
      # query = from c in "recent_chats",
      #       join: u in "users", on: c.user_id == u.id,
     Repo.all(query)
  end

  # add recent chat
  def add_recent_chat(attrs) do
    # TODO: figure how to do this with upserts.
    chat = Repo.get_by(RecentChat, [user_id: attrs["user_id"],
                      chat_with_user_id: attrs["chat_with_user_id"]])

    # An entry is added with message_text "start chat", once a user picks a contact to talk to
    # all other times, attrs will contain
    if is_nil(chat) do
      %RecentChat{}
      |> RecentChat.changeset(attrs)
      |> Repo.insert()
    else
      dt =  NaiveDateTime.local_now()
      update_params = %{last_message: attrs["last_message"], last_message_datetime: dt}
      chat
      |> RecentChat.changeset(update_params)
      |> Repo.update()
    end
  end


  def update_recent_chat(attrs) do
    chat = Repo.get_by(RecentChat, [user_id: attrs["from_id"],
                      chat_with_user_id: attrs["to_id"]])

    dt = NaiveDateTime.local_now()
    update_params = %{last_message: attrs["message"], last_message_datetime: dt}

    chat
    |> RecentChat.changeset(update_params)
    |> Repo.update()
  end


end
