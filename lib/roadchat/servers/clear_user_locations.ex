defmodule Roadchat.Servers.ClearUserLocations do
  use GenServer
  alias Roadchat.Repos.GeoLocation

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here
    IO.puts "Hi from genserver - ClearUserLocations"
    clear_user_locations()
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    # Process.send_after(self(), :work, 1 * 60 * 60 * 1000) # every hour
    Process.send_after(self(), :work, 5 * 60  * 1000) # 5 minutes
  end

  def clear_user_locations() do
    GeoLocation.expire_location_records()
  end
end
