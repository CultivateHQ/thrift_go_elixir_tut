defmodule GuitarsServiceHandlerTest do
  use ExUnit.Case, async: true

  alias Thrift.Generated.GuitarsService.Binary.Framed.{Server, Client}

  setup_all do
    mod_name = GuitarsServiceHandler
    :rand.seed(:exs64)
    server_port = :rand.uniform(10000) + 12000

    {:ok, server_pid} = Server.start_link(mod_name, server_port, [])

    on_exit fn ->
      stop_server(server_pid)
    end

    {:ok, handler_name: mod_name, port: server_port}
  end

  setup(context) do
    {:ok, db_pid} = Db.start_link([])

    on_exit fn ->
      if Process.alive?(db_pid) do
        ref = Process.monitor(db_pid)
        Db.stop()

        receive do
          {:DOWN, ^ref, _, _, _} ->
            :ok
        end
      end
    end

    {:ok, client} = Client.start_link("localhost", context.port, name: TestClientName)

    {:ok, client: client}
  end

  def stop_server(server_pid) do
    Server.stop(server_pid)
  catch :exit, _ ->
    :ok
  end

  test "all" do
    # all() :: [%Thrift.Generated.Guitar{}]
  end

  test "create" do
    # create(brand :: String.t(), model :: String.t()) :: %Thrift.Generated.Guitar{}
  end

  test "remove" do
    # remove(id :: Thrift.i64()) :: %Thrift.Generated.Guitar{}
  end

  test "remove non-existant" do
    # remove(id :: Thrift.i64()) :: %Thrift.Generated.Guitar{}
  end

  test "show" do
    # show(id :: Thrift.i64()) :: %Thrift.Generated.Guitar{}
  end

  test "show non-existant" do
    # show(id :: Thrift.i64()) :: %Thrift.Generated.Guitar{}
  end
end
