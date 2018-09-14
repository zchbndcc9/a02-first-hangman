defmodule Hangman.Game do

  defmodule State do
    defstruct(
      state:      :initializing, 
      turns_left: 7, 
      used:       [],
      letters:    []
    ) 
  end

  def new_game() do
    new_word()
    |> (fn word -> %Hangman.Game.State{letters: word} end).()
  end

  def new_word() do
    Dictionary.random_word()
    |> String.split("", trim: true)
  end

end