defmodule Db do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def create(pid, record) do
    GenServer.cast(pid, {:create, record})
  end

  def all(pid) do
    GenServer.call(pid, :all)
  end

  def stop(pid) do
    GenServer.stop(pid)
  end

  # Callbacks

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_cast({:create, record}, state) do
    {:noreply, Map.put(state, 0, record)}
  end

  def handle_call(:all, _from, state) do
    {:reply, Map.values(state), state}
  end
end
