defmodule GuitarsClient do
  @moduledoc """
  A command-line client for the Thrift based Guitars API.
  """
  alias Thrift.Generated.Guitars.Binary.Framed.Client

  @doc """
  The entry point for the client.
  """
  def main(_args) do
    IO.puts("Starting ...")

    {:ok, client} = Client.start_link("localhost", 9090, [])

    Client.create!(client, "Charvel", "San Dimas")
    Client.create!(client, "Fender", "Telecaster")
    Client.create!(client, "Fender", "Stratocaster")
    Client.create!(client, "Fender", "Jaguar")
    Client.create!(client, "Gibson", "Les Paul")
    Client.create!(client, "Gibson", "SG")

    response = Client.all!(client)

    IO.inspect(response)
  end
end
