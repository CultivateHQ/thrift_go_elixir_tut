defmodule GuitarsClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :guitars_client,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: [:thrift | Mix.compilers],
      thrift: [
        files: Path.wildcard("../thrift-defs/**/*.thrift"),
        output_path: "lib/"
      ],
      escript: [main_module: GuitarsClient],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:thrift, github: "pinterest/elixir-thrift"}
    ]
  end
end
