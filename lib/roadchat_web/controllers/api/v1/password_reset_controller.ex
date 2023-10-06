defmodule RoadchatWeb.Api.V1.ResetPasswordController do
  use RoadchatWeb, :controller
  alias Roadchat.Accounts

  def send_reset_token(conn, %{"user" => user}) do
    if user = Accounts.get_user_by_email(user["email"]) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )

      json(conn, %{ok: "Password reset instructions sent"})
    end
  end

  def show_reset_form(conn, %{"token" => token}) do
    # TODO: if user is found redirect to password reset papge

    # if user = Accounts.get_user_by_email(user["email"]) do
    #   Accounts.deliver_user_reset_password_instructions(
    #     user,
    #     &url(~p"/users/reset_password/#{&1}")
    #   )

    #   json(conn, %{ok: "Password reset instructions sent"})
    # end

    IO.inspect(token)
    json(conn, %{ok: "Password reset"})
  end
end
