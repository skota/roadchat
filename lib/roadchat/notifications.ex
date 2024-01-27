defmodule Roadchat.Notifications do
  def send_message(message, device_token) do
    # get oauth token
    token =  Goth.fetch!(Roadchat.Goth)

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{token.token}"}
    ]

    body = "{
        \"message\":{
            \"token\":\"#{device_token}\",
            \"notification\":{
                \"body\":\"#{message}\",
                \"title\":\"Roadchat\"
            }
          }
    }"
    # {:ok, json_body} = Jason.encode(body)
    notifications_url = System.get_env("FB_NOTIFICATION_URL")
    {:ok, response} = HTTPoison.post(notifications_url, body, headers, [])
    IO.inspect(response)
  end
end
