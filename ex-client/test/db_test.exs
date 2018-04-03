defmodule DbTest do
  use ExUnit.Case

  setup do
    _ = start_supervised!(Db)

    %{}
  end

  @entry_a %{"one" => :two, 3 => "four"}
  @entry_b %{"x" => :y, 1 => "two"}

  test "records can be added" do
    :ok = Db.create(@entry_a)
    :ok = Db.create(@entry_b)

    assert(Db.all() == [@entry_a, @entry_b])
  end

  test "records can be retrieved" do
    :ok = Db.create(@entry_a)
    :ok = Db.create(@entry_b)

    assert(Db.find(0) == @entry_a)
    assert(Db.find(1) == @entry_b)
  end

  test "records can be removed" do
    :ok = Db.create(@entry_a)
    :ok = Db.create(@entry_b)

    assert(Db.remove(1) == @entry_b)
    assert(Db.remove(1) == :not_found)

    assert(Db.find(0) == @entry_a)
    assert(Db.find(1) == :not_found)

    :ok = Db.create(@entry_b)
    assert(Db.find(2) == @entry_b)
  end
end
