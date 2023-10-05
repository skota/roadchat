defmodule Roadchat.Repo do
  use Ecto.Repo,
    otp_app: :roadchat,
    adapter: Ecto.Adapters.Postgres
end
