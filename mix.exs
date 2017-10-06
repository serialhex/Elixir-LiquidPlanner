defmodule Liquidplanner.Mixfile do
  use Mix.Project

  def project do
    [
      app: :liquidplanner,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Liquidplanner.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:json_web_token, "~> 0.2.10"},
      {:poison, "~> 3.1.0"},
      {:httpoison, "~> 0.13"}
    ]
  end
end
