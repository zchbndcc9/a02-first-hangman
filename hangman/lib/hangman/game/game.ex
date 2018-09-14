defmodule Hangman.Game do

  def new_game(), do: %Hangman.Game.Tally{}
  def new_word() do
    Dictionary.random_word()
    |> String.split("", trim: true)
  end

end