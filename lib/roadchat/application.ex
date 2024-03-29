defmodule Roadchat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do

    # credentials = File.read!("/Users/sriramkota/Downloads/roadchatapp-firebase-adminsdk-2kwnr-7a5aa2c73b.json")
    # |> Jason.decode!()
    credentials ="GOOGLE_APPLICATION_CREDENTIALS_JSON"
      |> System.fetch_env!()
      |> File.read!()
      |> Jason.decode!()

    source = {:service_account, credentials}

    children = [
      # Start the Telemetry supervisor
      RoadchatWeb.Telemetry,
      # Start the Ecto repository
      Roadchat.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Roadchat.PubSub},
      # Start Finch
      {Finch, name: Roadchat.Finch},
      # Start the Endpoint (http/https)
      RoadchatWeb.Endpoint,
      # Roadchat.StateBucket,
      {Roadchat.Servers.UserStateServer, %{}},
      {Roadchat.Servers.UserContactStateServer, %{}},
      {Roadchat.Servers.LoadContacts, %{}},
      {Roadchat.Servers.UserProximity, %{}},
      {Goth, name: Roadchat.Goth, source: source}
      # {Roadchat.Servers.ClearUserLocations, %{}},
      # Start a worker by calling: Roadchat.Worker.start_link(arg)
      # {Roadchat.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Roadchat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RoadchatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
