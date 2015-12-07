defmodule Etudes9 do
  @moduledoc """
    Chapter #9 - processes
  """

  require Logger
  require IEx

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
      cards =
        for honour <- 2 .. 14,
          suit <- [ :spade, :heart, :diamond, :club ] do
            %Card{ honour: honour, suit: suit }
        end
      %Deck{ cards: cards }
    end

    @doc """
      Shuffle the deck of cards
    """
    @spec shuffle(%Deck{}) :: %Deck{}
    def shuffle(deck) do
      deck
    end

    @doc """
      Validate whether all cards are present & there are not duplicates
    """
    @spec validate_deck(%Deck{}) :: boolean()
    def validate_deck(deck) do
      context = [ spades: %{}, hearts: %{}, diamonds: %{}, clubs: %{} ]
      built_context = validate_deck_with_context(deck.cards, context)
      # Logger.info "Spades: |#{inspect built_context[:spades] |> Map.keys |> Enum.count}|."
      (13 == built_context[:spades] |> Map.keys |> Enum.count) and
      (13 == built_context[:hearts] |> Map.keys |> Enum.count) and
      (13 == built_context[:diamonds] |> Map.keys |> Enum.count) and
      (13 == built_context[:clubs] |> Map.keys |> Enum.count)
    end

    @spec validate_deck_with_context(list(), list()) :: list()
    defp validate_deck_with_context(cards, [ spades: spades, hearts: hearts, diamonds: diamonds, clubs: clubs ]) do
      case cards do
        [ card | rest ] ->
          new_context =
            case card do
              %Card{ honour: honour, suit: :spade } -> [ spades: Map.put_new(spades, honour, true), hearts: hearts, diamonds: diamonds, clubs: clubs ]
              %Card{ honour: honour, suit: :heart } -> [ spades: spades, hearts: Map.put_new(hearts, honour, true), diamonds: diamonds, clubs: clubs ]
              %Card{ honour: honour, suit: :diamond } -> [ spades: spades, hearts: hearts, diamonds: Map.put_new(diamonds, honour, true), clubs: clubs ]
              %Card{ honour: honour, suit: :club } -> [ spades: spades, hearts: hearts, diamonds: diamonds, clubs: Map.put_new(clubs, honour, true) ]
            end
          validate_deck_with_context(rest, new_context)
        _ -> [ spades: spades, hearts: hearts, diamonds: diamonds, clubs: clubs ]
      end
    end

    @doc """
      Deal the deck between the players
    """
    @spec deal(%Deck{}, list()) :: list()
    def deal(deck, players) do
      []
    end

    @doc """
      Validate whether all cards are present & there are not duplicates
    """
    @spec validate_hands(list()) :: boolean()
    def validate_hands(players) do
      false
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
      -1
    end
  end
end
