defmodule Hangman.Game do

  def new_game(), do: %Hangman.Game.Tally{}
  def new_word() do
    Dictionary.random_word()
    |> String.split("", trim: true)
  end

  # Filters Hangman.Game struct to remove the word_to_guess
  def tally(tally) do
    tally
    |> Map.from_struct
    |> Enum.reject(fn {key, _value} -> key == :word_to_guess end)
    |> Enum.into(%{})
  end


end
