defmodule Consul.Mixfile do
  use Mix.Project

  def project do
    [app: :consul,
     version: "0.1.6",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     dialyzer: [plt_add_deps: :transitive],
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
     deps: deps(),
     name: "Consul",
     source_url: "https://github.com/Toady00/consul",
     homepage_url: "https://github.com/Toady00/consul",
     description: description(),
     package: package(),
     docs: [main: "readme", extras: ["README.md"], output: "docs"]]
  end

  def application do
    [applications: [:logger, :httpoison, :poison],
     mod: {Consul, []}]
  end

  defp deps do
    [
      {:dialyxir, "~> 0.4", only: :dev},
      {:excoveralls, "~> 0.5", only: :test},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:dogma, "~> 0.1", only: :dev},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:ex_unit_notifier, "~> 0.1", only: :test},
      {:poison, "~> 3.0"},
      {:httpoison, "~> 0.11.0"},
      {:ex_doc, "~> 0.14", only: :dev}
    ]
  end

  defp description do
    """
    100% API Complete Consul Client written in Elixir
    """
  end

  defp package do
    [
      name: :consul_client,
      files: ["lib", "mix.exs", "README.md", "LICENSE.txt", "docs"],
      maintainers: ["G. Brandon Dennis"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/toady00/consul",
              "Documentation" => "https://toady00.github.io/consul"}
    ]
  end
end
