defmodule Hangman.Game do
  defstruct game_state: :initializing,
            turns_left: 7,
            letters: [],
            used: [],
            word_to_guess: [],
            last_guess: ''

  def new_game() do
    word = new_word()
    letters = initialize_letters(word)

    %Hangman.Game{
      letters: letters,
      word_to_guess: word
    }
  end

  def new_word() do
    Dictionary.random_word()
    |> String.split("", trim: true)
  end

  def initialize_letters(word) do
    Enum.to_list(word)
    |> Enum.map(fn _x -> '_' end)
  end
end
