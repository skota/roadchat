defmodule Roadchat.Servers.UserStateServer do
  use GenServer

  # Client
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, 0,  name: __MODULE__)
  end

  def add_user(user) do
    GenServer.cast(__MODULE__, {:add_user, user})
  end

  def get_user() do
    GenServer.call(__MODULE__, {:get_user})
  end

  # Server (callbacks) -----------------
  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  # def handle_call({:get_user}, from, state) do
  #   IO.inspect "inside handle call :get_user"
  #   IO.inspect state

  #   if [to_caller | _new_state] = state do
  #     new_state = to_caller
  #     {:reply, to_caller, new_state}
  #   else
  #     # new_state = to_caller
  #     {:reply, to_caller, to_caller}
  #   end
  def handle_call({:get_user}, _from, state) do
    IO.inspect "inside handle call :get_user 1"
    IO.inspect state
    [to_caller | _new_state] = state
    # {:reply, to_caller, new_state}
    {:reply, to_caller, state}
  end

  @impl true
  def handle_cast({:add_user, element}, state) do
    IO.inspect "inside handle cast: add_user"
    new_state = [element | state]
    IO.inspect new_state
    {:noreply, new_state}
  end

end
