defmodule Etudes9 do
  @moduledoc """
    Chapter #9 - processes
  """

  require Logger
  require IEx

  # suits = { :spade, :heart, :diamond, :club }

  defmodule Card do
    defstruct honour: 2, suit: :spade
  end

  defmodule Deck do
    defstruct cards: []

    @doc """
      Create new deck of cards
    """
    @spec create :: %Deck{}
    def create do
    end

    @doc """
      Shuffle the deck of cards
    """
    @spec shuffle(%Deck{}) :: %Deck{}
    def shuffle(deck) do
    end

    @doc """
      Deal the deck between the players
    """
    @spec deal(%Deck{}, list()) :: list()
    def deal(deck, players) do
    end

    @doc """
      Validate whether all cards are present & there are not duplicates
    """
    @spec validate(list()) :: boolean()
    def validate(players) do
    end

    @doc """
      Draw cards, find out the winner & collect the bounty
    """
    @spec play_round(list()) :: nil
    def play_round(players) do
    end

    @doc """
      Check the victory conditions
    """
    @spec check_victory_conditions(list()) :: integer()
    def check_victory_conditions(players) do
    end

  end
end
