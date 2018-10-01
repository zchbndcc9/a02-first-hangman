defmodule Hangman.Game do
  defstruct game_state: :initializing,
            turns_left: 7,
            letters: [],
            used: [],
            word_to_guess: [],
            last_guess: ''

  # Creates a game struct with new word and the corresponding blank spaces for
  # letters. In order to maintain immutability, I dont passed my state to fxns
  def new_game() do
    word = new_word()
    letters = create_blank_board(word)

    %Hangman.Game{
      letters: letters,
      word_to_guess: word
    }
  end

  def new_word() do
    Dictionary.random_word
    |> String.split("", trim: true)
  end

  # Creates a blank hangman board that is the same length as the word provided
  def create_blank_board(word) do
    word
    |> Enum.to_list
    |> Enum.map(fn _x -> '_' end)
  end
end
