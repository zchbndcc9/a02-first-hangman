defmodule Hangman.Game do
  defstruct game_state: :initializing,
            turns_left: 7,
            letters: [],
            used: [],
            word_to_guess: [],
            last_guess: ""

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
    game.used
      |> contains_letter?(guess)
      |> already_guessed(game)
  end

  # Creates a blank hangman board that is the same length as the word provided
  def create_blank_board(word) do
    word
      |> Enum.to_list
      |> Enum.map(fn _x -> '_' end)
  end

  def already_guessed(true, game = %Hangman.Game{}),  do: %{game | game_state: :already_guessed}
  def already_guessed(false, game = %Hangman.Game{}), do: %{game | game_state: :continue}

  def replace_letters(list, [], [], _guess),                                  do: Enum.reverse(list)
  def replace_letters(list, [_l | letters], [guess | word_to_guess], guess),  do: replace_letters([guess | list], letters, word_to_guess, guess)
  def replace_letters(list, [l | letters], [_h | word_to_guess], guess),      do: replace_letters([l | list], letters, word_to_guess, guess)

  def check_guess(game = %Hangman.Game{game_state: :already_guessed}, _), do: game
  def check_guess(game = %Hangman.Game{}, guess) do
    game = %{game | last_guess: guess, used: [guess | game.used] }

    game.word_to_guess
      |> contains_letter?(guess)
      |> letter_in_word(game, guess)
  end

  def letter_in_word(true, game, guess) do
    new_board = replace_letters([], game.letters, game.word_to_guess, guess)
    IO.inspect new_board

    %{ game |
      game_state: :good_guess,
      letters: new_board
    }
  end

  def letter_in_word(false, game, _guess) do
    %{ game |
      game_state: :bad_guess,
      turns_left: game.turns_left - 1
    }
  end

  def change_player_status(game = %Hangman.Game{game_state: :bad_guess, turns_left: 0}),                              do: %{ game | game_state: :lost }
  def change_player_status(game = %Hangman.Game{game_state: :good_guess, word_to_guess: word, letters: word} = game), do: %{ game | game_state: :won }
  def change_player_status(game = %Hangman.Game{}),                                                                   do: game

  # Checks a list to determine whether or not it contains a letter
  def contains_letter?(board, guess) do
    Enum.any?(board, fn letter -> letter == guess end)
  end
end
