defmodule Etudes9Test do
  use ExUnit.Case
  doctest Etudes9

  require Logger
  require IEx

  test "generate deck is proper" do
    deck = Etudes9.Deck.create()
    valid = Etudes9.Deck.validate_deck(deck)
    assert valid == true
  end

  test "shuffled deck is proper" do
    deck = Etudes9.Deck.create()
    shuffled = Etudes9.Deck.shuffle(deck)
    valid = Etudes9.Deck.validate_deck(shuffled)
    assert valid == true
  end

  test "two shuffled decks are different" do
    deck = Etudes9.Deck.create()
    shuffled1 = Etudes9.Deck.shuffle(deck)
    # Logger.info "Shuffled #1: |#{inspect shuffled1}|."

    shuffled2 = Etudes9.Deck.shuffle(deck)
    # Logger.info "Shuffled #2: |#{inspect shuffled2}|."

    zipped = Enum.zip(shuffled1.cards, shuffled2.cards)
    different = Enum.any?(zipped, fn ({card1, card2}) ->
      card1.honour !== card2.honour or card1.suit !== card2.suit
    end)

    assert different == true
  end

  test "deck dealt between 2 players is still proper"

  test "round - clear winner"

  test "round - same card drawn"

  test "round - same card drawn twice"

  test "round - too few cards"

  test "round - victory conditions mets"

end
