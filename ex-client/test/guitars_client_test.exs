defmodule GuitarsClientTest do
  use ExUnit.Case
  doctest GuitarsClient

  test "greets the world" do
    assert GuitarsClient.hello() == :world
  end
end
