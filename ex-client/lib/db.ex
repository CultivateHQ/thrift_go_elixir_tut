defmodule Db do
  use Agent

  @name __MODULE__

  def start_link(_opts) do
    records = %{}
    next_id = 0
    init_fun = fn -> {records, next_id} end
    Agent.start_link(init_fun, name: @name)
  end

  def create(record) do
    Agent.update(@name, fn {records, next_id} ->
      records = Map.put(records, next_id, record)
      {records, next_id + 1}
    end)
  end

  def find(id) do
    Agent.get(@name, fn {records, _} ->
      Map.get(records, id, :not_found)
    end)
  end

  def all do
    Agent.get(@name, fn {records, _} ->
      Map.values(records)
    end)
  end

  def remove(id) do
    Agent.get_and_update(@name, fn {records, next_id} ->
      {record, records} = Map.pop(records, id, :not_found)
      {record, {records, next_id}}
    end)
  end

  def stop do
    Agent.stop(@name)
  end
end
