defmodule Etudes9 do
  @moduledoc """
    Chapter #9 - processes
  """

  require Logger
  require IEx

  defmodule Card do
    defstruct honour: 2, suit: :spade
  end

  @doc """
    Create a new player
  """
  @spec create_player() :: pid()
  def create_player() do
    dealer = self()
    player = spawn fn -> player_loop(dealer, []) end
    # Logger.info "Dealer #{inspect dealer} spawned a new player #{inspect player}."
    player
  end

  @spec player_loop(pid(), list()) :: list()
  defp player_loop(dealer, cards) do
    receive do
      {:pick_card, card} ->
        # Logger.info "Player #{inspect self()} picking card: #{inspect card}."
        new_cards = cards ++ [ card ]
        player_loop(dealer, new_cards)
      {:draw_card} ->
        new_cards =
          case cards do
            [ drawn_card | rest ] ->
              # Logger.info "Player #{inspect self()} drawing card: #{inspect drawn_card} & return it to dealer #{inspect dealer}."
              send(dealer, {:drawn_card, drawn_card})
              rest
            [] ->
              # Logger.info "Player #{inspect self()} doesn't have any cards to give back to dealer #{inspect dealer}."
              send(dealer, {:empty_hand})
              []
          end
        player_loop(dealer, new_cards)
      {:game_over} -> cards
    end
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
      # ordered order :)
      ordered = Enum.to_list 0 .. 51
      # determine order
      :random.seed(:erlang.unique_integer)
      reordered = cherry_pick(ordered, [])
      # fill shuffled deck in assumed order
      shuffled = reordered |>
        Enum.map(fn (elem) -> Enum.at(deck.cards, elem) end)
      %Deck{ cards: shuffled }
    end

    @spec cherry_pick(list(), list()) :: list()
    defp cherry_pick(basket, result) do
      # Logger.info "Basket: |#{inspect result}|."
      cond do
        Enum.count(basket) > 0 ->
          ordinal = :random.uniform(Enum.count(basket)) - 1
          picked = Enum.at(basket, ordinal)
          reduced = List.delete_at(basket, ordinal)
          cherry_pick(reduced, [ picked ] ++ result)
        true -> result
      end
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
      case deck do
        %Deck{ cards: [ card | rest_cards ] } ->
          case players do
            [ player | rest_players ] ->
              send(player, {:pick_card, card})
              deal(%Deck{ cards: rest_cards }, rest_players ++ [ player ])
            _ -> raise RuntimeError, "No players to deal for!"
          end
        %Deck{ cards: [] } -> players
      end
    end

    @doc """
      Collect all the cards back from the players
    """
    @spec collect(list(), %Deck{} | none) :: %Deck{}
    def collect(players, collected \\ %Deck{ cards: [] }) do
      case players do
        [ player | rest_players ] ->
          send(player, {:draw_card})
          receive do
            {:drawn_card, drawn_card} ->
              # Logger.info "Collected card: #{inspect drawn_card}, current stack depth: #{inspect collected.cards|> Enum.count}."
              collect(rest_players ++ [ player ], %Deck{ cards: [ drawn_card ] ++ collected.cards })
            {:empty_hand} -> collect(rest_players, collected)
            after
              1_000 -> raise RuntimeError, "Player #{inspect player} not responding!"
          end
        [] -> collected
      end
    end

    @doc """
      Draw cards, find out the winner & collect the bounty
    """
    @spec play_round(list()) :: list()
    def play_round(players) do
      players
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
