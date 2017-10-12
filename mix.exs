defmodule LiquidPlanner.Mixfile do
  use Mix.Project

  def project do
    [
      app: :liquidplanner,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {LiquidPlanner, []}
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

  defp description() do
    "An interface to the LiquidPlanner API via Elixir."
  end

  defp package() do
    [
      maintainers: ["Justin Patera"],
      licenses: ["MIT License"],
      links: %{"GitHub" => "https://github.com/serialhex/Elixir-LiquidPlanner"}
    ]
  end
end
