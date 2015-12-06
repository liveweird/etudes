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

  test "shuffled deck is proper"

  test "two shuffled decks are different"

  test "deck dealt between 2 players is still proper"

  test "round - clear winner"

  test "round - same card drawn"

  test "round - same card drawn twice"

  test "round - too few cards"

  test "round - victory conditions mets"

end
