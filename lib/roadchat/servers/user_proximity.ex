defmodule Roadchat.Servers.UserProximity do
  use GenServer
  alias Roadchat.Repos.GeoLocation
  alias Roadchat.Servers.UserStateServer

  # @tab :user_data
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    IO.puts "Hi from genserver - UserProximity"
    GeoLocation.get_distance_between_points()
    # 4 - if any users are nearby, send notification to current user "user x is nearby"
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 4 * 60   * 1000) # every 4 mins
  end

end
