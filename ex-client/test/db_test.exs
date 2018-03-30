defmodule DbTest do
  use ExUnit.Case

  setup do
    pid = start_supervised!(Db)

    %{db: pid}
  end

  test "records can be added", %{db: pid} do
    :ok = Db.create(pid, %{"one" => :two, 3 => "four"})
    assert(Db.all(pid) == [%{"one" => :two, 3 => "four"}])
  end
end
