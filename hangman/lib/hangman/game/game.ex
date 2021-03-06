defmodule Hangman.Game do
  defstruct game_state: :initializing,
            turns_left: 7,
            letters: [],
            used: [],
            word_to_guess: [],
            last_guess: ""

  ## [ API ]

  # Creates a game struct with new word and the corresponding blank spaces for
  # letters
  def new_game() do
    word = new_word()
    letters = create_blank_board(word)

    %Hangman.Game{
      letters: letters,
      word_to_guess: word
    }
  end

  # Filters Hangman.Game struct to remove the word_to_guess
  def tally(tally) do
    tally
      |> Map.from_struct()
      |> Enum.reject(fn {key, _value} -> key == :word_to_guess end)
      |> Enum.into(%{})
  end

  def make_move(game, guess) do
    game = game
      |> check_already_guessed(guess)
      |> check_guess(guess)
      |> player_status
    {game, tally(game)}
  end

  def check_already_guessed(game, guess) do
    game.used
      |> contains_letter?(guess)
      |> already_guessed(game)
  end

  def already_guessed(true, game = %Hangman.Game{}),  do: %{game | game_state: :already_guessed}
  def already_guessed(false, game = %Hangman.Game{}), do: %{game | game_state: :continue}

  def check_guess(game = %Hangman.Game{game_state: :already_guessed}, _), do: game
  def check_guess(game = %Hangman.Game{}, guess) do
    game = %{game | last_guess: guess, used: [guess | game.used]}

    game.word_to_guess
      |> contains_letter?(guess)
      |> letter_in_word(game, guess)
  end

  def replace_letters(list, [], [], _guess),                        do: Enum.reverse(list)
  def replace_letters(list, [_l | letters], [guess | word], guess), do: replace_letters([guess | list], letters, word, guess)
  def replace_letters(list, [l | letters], [_h | word], guess),     do: replace_letters([l | list], letters, word, guess)

  def letter_in_word(true, game, guess) do
    new_board = replace_letters([], game.letters, game.word_to_guess, guess)
    %{game | game_state: :good_guess, letters: new_board}
  end

  def letter_in_word(false, game, _guess) do
    %{game | game_state: :bad_guess, turns_left: game.turns_left - 1}
  end

  def player_status(game) do
    case game do
      %Hangman.Game{turns_left: 0} -> %{game | game_state: :lost, letters: game.word_to_guess}
      %Hangman.Game{word_to_guess: word, letters: word} -> %{game | game_state: :won}
      %Hangman.Game{} -> game
    end
  end
  ## [ Helpers ]

  def new_word() do
    Dictionary.random_word()
      |> String.split("", trim: true)
  end

  # Checks a list to determine whether or not it contains a letter
  def contains_letter?(board, guess) do
    Enum.any?(board, fn letter -> letter == guess end)
  end

  # Creates a blank hangman board that is the same length as the word provided
  def create_blank_board(word) do
    word
      |> Enum.to_list()
      |> Enum.map(fn _x -> '_' end)
  end
end
