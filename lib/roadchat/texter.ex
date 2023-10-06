defmodule Roadchat.Texter do
  def send_sms(to_number, message) do
    # read account_sid amd auth token from env...
    # Application.get_env(:yardygram_web, :account_sid)
    account_sid = System.get_env("ACCOUNT_SID")
    auth_token = System.get_env("AUTH_TOKEN")
    send_from_number = System.get_env("SEND_FROM_NUMBER")
    # https://www.twilio.com/docs/sms/send-messages
    # https://gist.github.com/thluiz/24494c150640b87d7d7a
    auth = [hackney: [basic_auth: {account_sid, auth_token}]]

    url =
      "https://api.twilio.com/2010-04-01/Accounts/#{account_sid}/Messages.json"

    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Accept", "text/html"}
    ]

    encoded_text = URI.encode_www_form(message)
    from = URI.encode_www_form("#{send_from_number}")
    to = URI.encode_www_form("#{to_number}")
    body = "Body=#{encoded_text}&From=#{from}&To=#{to}"

    response = HTTPoison.post(url, body, headers, auth)
    IO.inspect(response)

  end
end
