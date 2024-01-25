defmodule Roadchat.Servers.UserContactStateServer do
  use GenServer

  # Client
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [],  name: __MODULE__)
  end

  def add_chat_list(users) do
    GenServer.cast(__MODULE__, {:add_chat_list, users})
  end

  def get_chat_list() do
    GenServer.call(__MODULE__, {:get_chat_list})
  end

  # Server (callbacks) -----------------
  @impl true
  def init(state) do
    {:ok, state}
  end


  @impl true
  def handle_call({:get_chat_list}, _from, state) do
    [to_caller | new_state] = state
    {:reply, to_caller, new_state}
  end

  @impl true
  def handle_cast({:add_chat_list, element}, state) do
    new_state = [element | state]
    {:noreply, new_state}
  end

end
