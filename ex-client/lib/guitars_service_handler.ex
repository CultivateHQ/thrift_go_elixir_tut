defmodule GuitarsServiceHandler do
  @behaviour Thrift.Generated.GuitarsService.Handler

  def all(), do: [%Thrift.Generated.Guitar{}]
  def create(brand, model), do: %Thrift.Generated.Guitar{}
  def remove(id), do: %Thrift.Generated.Guitar{}
  def show(id), do: %Thrift.Generated.Guitar{}
end
