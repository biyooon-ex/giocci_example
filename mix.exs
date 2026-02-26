defmodule GiocciExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :giocci_example,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      # {:giocci, path: "../giocci"}
      # {:giocci, git: "https://github.com/biyooon-ex/giocci.git", branch: "dev/v0.3.0-rc2"}
      {:giocci, "~> 0.3.0"}
    ]
  end
end
