defmodule HumanPlayer.Mixfile do
  use Mix.Project

  def project do
    [
      app:       :human_player,
      version:   "0.1.0",
      elixir:    "~> 1.7",
      deps:     deps(),
      start_permanent: Mix.env() == :prod
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      { :hangman, path: "../hangman" }
    ]
  end
end
