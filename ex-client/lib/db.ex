defmodule Db do
  use GenServer

  @name __MODULE__

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :no_args, [name: @name])
  end

  def create(record) do
    GenServer.call(@name, {:create, record})
  end

  def find(id) do
    GenServer.call(@name, {:find, id})
  end

  def all do
    GenServer.call(@name, :all)
  end

  def remove(id) do
    GenServer.call(@name, {:remove, id})
  end

  def stop do
    GenServer.stop(@name)
  end

  # Callbacks

  def init(_opts) do
    records = %{}
    next_id = 0
    {:ok, {records, next_id}}
  end

  def handle_call({:create, record}, _from, {records, next_id}) do
    records = Map.put(records, next_id, record)
    {:reply, :ok, {records, next_id + 1}}
  end

  def handle_call(:all, _from, state = {records, _}) do
    {:reply, Map.values(records), state}
  end

  def handle_call({:find, id}, _from, state = {records, _}) do
    {:reply, Map.get(records, id, :not_found), state}
  end

  def handle_call({:remove, id}, _from, {records, next_id}) do
    {record, records} = Map.pop(records, id, :not_found)
    {:reply, record, {records, next_id}}
  end
end
