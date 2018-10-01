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
  
  # Filters Hangman.Game struct to remove the word_to_guess
  def tally(tally) do
    tally
    |> Map.from_struct
    |> Enum.reject(fn {key, _value} -> key == :word_to_guess end)
    |> Enum.into(%{})
  end

  def make_move(game, guess) do
    game
      |> check_already_guessed(guess)
      |> check_guess(guess)
      |> change_player_status
  end

  def check_already_guessed(game, guess) do
    game.already_used
      |> contains_letter?(guess)
      |> already_guessed(game)
  end

  # Creates a blank hangman board that is the same length as the word provided
  def create_blank_board(word) do
    word
    |> Enum.to_list
    |> Enum.map(fn _x -> '_' end)
    
  def already_guessed(true, game) do
    put_in(game, :game_status, :already_guessed)
  end

  def already_guessed(false, game) do
    game
  end

  def check_guess(%Hangman.Game{game_status: :already_guessed}, _) do
    game
  end

  def check_guess(game, guess) do
    game = Struct.put_in(game, [last_guess: guess, already_guessed: [guess | game.already_guessed]] )

    game.word_to_guess
      |> contains_letter?(guess)
      |> letter_in_word(game, guess)
  end

  def letter_in_word(true, game, guess) do
    put_in(game, :game_status, :good_guess)
  end

  def letter_in_word(false, game, guess) do
    put_in(game, [game_status: :bad_guess, turns_left: game.turns_left - 1])
  end

  def change_player_status(game = %Hangman.Game{game_status: :already_guessed}) do
    game
  end

  def change_player_status(game = %Hangman.Game{game_status: :bad_guess, turns_left: 0}) do
    put_in(game, :game_status, :lost)
  end

  def change_player_status(game = %Hangman.Game{game_status: :good_guess, word_to_guess: word, letters: word}) do
    put_in(game, :game_status, :won)
  end

  def change_player_status(game = %Hangman.Game{game_status: :good_guess, word_to_guess: _, letters: _}) do
    game
  end

  # Checks a list to determine whether or not it contains a letter
  def contains_letter?(board, guess) do
    Enum.any?(board, fn letter -> letter == guess end)
  end
end
