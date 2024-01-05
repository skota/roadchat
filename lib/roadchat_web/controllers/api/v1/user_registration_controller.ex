defmodule RoadchatWeb.Api.V1.UserRegistrationController do
  use RoadchatWeb, :controller

  alias Roadchat.{Accounts, UtilHelpers}
  alias RoadchatWeb.UserAuth
  require Logger

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        IO.inspect("created user")
        conn =
          conn
          |> put_status(201)

        json(conn, %{id: user.id})

      {:error, %Ecto.Changeset{} = changeset} ->
        # send back error
        IO.inspect changeset
        Logger.info("Unable to create user")

        conn =
          conn
          |> put_status(401)

        {:error, errors} = UtilHelpers.return_errors(changeset)

        IO.inspect errors
        # errors = ChangesetErrors.translate_errors(changeset)
        json(conn, errors)
    end
  end

  def delete(conn, _params) do
    conn
    |> UserAuth.log_out_user()
  end
end
