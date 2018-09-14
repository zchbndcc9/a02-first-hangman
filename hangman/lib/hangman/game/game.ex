defmodule Hangman.Game do

  defmodule State do
    defstruct(
      state:      :initializing, 
      turns_left: 7, 
      used:       []
    ) 
  end

  def new_game(), do: %Hangman.Game.State{}

end