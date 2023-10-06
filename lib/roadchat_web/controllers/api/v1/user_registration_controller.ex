defmodule RoadchatWeb.Api.V1.UserRegistrationController do
  use RoadchatWeb, :controller

  alias Roadchat.{Accounts, UtilHelpers}
  alias RoadchatWeb.UserAuth
  require Logger

  def create(conn, %{"user" => user_params}) do
    IO.inspect user_params
    country = user_params["country"]

    user_params =
      if country == "Other" do
        Map.put(user_params, "country", "USA")
      else
        user_params
      end

    # set user type
    user_params = Map.put(user_params, "user_type", "u")

    case Accounts.register_user(user_params) do
      {:ok, user} ->
        IO.inspect("created user")

        conn =
          conn
          |> put_status(201)

        json(conn, %{id: user.id})

      {:error, %Ecto.Changeset{} = changeset} ->
        # send back error
        IO.inspect("Unable to create user")
        Logger.info("Unable to create user")

        conn =
          conn
          |> put_status(401)

        {:error, errors} = UtilHelpers.return_errors(changeset)
        # errors = ChangesetErrors.translate_errors(changeset)
        json(conn, %{error: errors})
    end
  end

  def delete(conn, _params) do
    conn
    |> UserAuth.log_out_user()
  end
end
