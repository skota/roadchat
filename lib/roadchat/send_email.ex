defmodule Roadchat.SendEmail do
  import Swoosh.Email
  alias Roadchat.Mailer

  def send_email() do
    user = %{"name" => "sriram", "email" => "sriram@erynai.com"}

   test_email = new()
            |> to({user["name"], user["email"]})
            |> from({"Sriram", "sriram.kota@gmail.com"})
            |> subject("Test email")
            |> html_body(
                  "<p>This is a test email</p>"
                )
            |> text_body("This is a test email")

    # Mailer.deliver(reset_email)
    with {:ok, metadata} <- Mailer.deliver(test_email) do
      {:ok, metadata}
    end

  end

end
