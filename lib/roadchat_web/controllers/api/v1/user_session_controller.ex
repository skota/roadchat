defmodule RoadchatWeb.Api.V1.UserSessionController do
  use RoadchatWeb, :controller

  alias Roadchat.{Accounts, Guardian, Settings}
  alias RoadchatWeb.UserAuth
  alias Roadchat.Repos.CustomerCards

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

        # settings = Settings.get_settings()
        settings = []
        customer_cards = CustomerCards.list_cards(user.id)
        # get customer car
        payment_method_id =
          if Enum.empty?(customer_cards) do
            nil
          else
            card = Enum.at(customer_cards, 0)
            card.payment_method_id
          end

        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, %{})

        json(conn, %{
          id: user.id,
          jwt: jwt,
          stripe_cust_id: user.stripe_cust_id,
          settings: settings,
          minutes: user.minutes,
          payment_method_id: payment_method_id
        })
    end
  end

  def delete(conn, _params) do
    conn
    |> UserAuth.log_out_user()
  end
end
