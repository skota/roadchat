defmodule RoadchatWeb.API.V1.DeviceController do
  use RoadchatWeb, :controller
  alias  Roadchat.Accounts

  def update_device_token(conn, %{"device" => params}) do
    IO.inspect params
    Accounts.update_device_token(params)

    conn
    |> put_status(200)
    |> json(%{ok: "updated devicetoken"})
  end

end
