defmodule Roadchat.Servers.LoadContacts do
  use GenServer
  alias Roadchat.Repos.GeoLocation
  alias Roadchat.Servers.UserContactStateServer


  # @tab :user_data

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

# :ets.new(:buckets_registry, [:named_table])
# :buckets_registry
# :ets.insert(:buckets_registry, {"foo", self()})
# true
# :ets.lookup(:buckets_registry, "foo")
# [{"foo", #PID<0.41.0>}]

  def init(state) do
    # :ets.new(@tab, [:set, :named_table, :public, read_concurrency: true, write_concurrency: true])
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    contacts = GeoLocation.get_user_contacts_for_chat()

    IO.puts "Hi from genserver - LoadData. These are the contacts"
    IO.inspect contacts
    UserContactStateServer.add_chat_list(contacts)
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    # Process.send_after(self(), :work, 2 * 60  * 60 * 1000) # every 2 hours
    Process.send_after(self(), :work, 2 * 60 * 60 * 1000) # every 3 minutes
  end

end
