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

  test "deck dealt between 2 players is still proper" do
    deck = Etudes9.Deck.create()
    shuffled = Etudes9.Deck.shuffle(deck)
    player1 = Etudes9.create_player()
    player2 = Etudes9.create_player()
    Etudes9.Deck.deal(shuffled, [player1, player2])
    collected = Etudes9.Deck.collect([player1, player2])
    valid = Etudes9.Deck.validate_deck(collected)
    assert valid == true
  end

  test "round - clear winner" do
    deck = Etudes9.Deck.create([ %Etudes9.Card{ honour: 2, suit: :spade },
                                 %Etudes9.Card{ honour: 3, suit: :spade },
                                 %Etudes9.Card{ honour: 4, suit: :spade },
                                 %Etudes9.Card{ honour: 5, suit: :spade }])
    player1 = Etudes9.create_player()
    player2 = Etudes9.create_player()
    Etudes9.Deck.deal(deck, [player1, player2])
    Etudes9.Deck.play_round([player1, player2])
    collected1 = Etudes9.Deck.collect([player1])
    collected2 = Etudes9.Deck.collect([player2])
    assert Enum.count(collected1.cards) == 1
    assert Enum.count(collected2.cards) == 3
    [ card1, card2, card3 ] = collected2.cards
    assert card1 == %Etudes9.Card{ honour: 5, suit: :spade}
    assert card2 == %Etudes9.Card{ honour: 2, suit: :spade}
    assert card3 == %Etudes9.Card{ honour: 3, suit: :spade}
  end

  test "round - same card drawn" do
    deck = Etudes9.Deck.create([ %Etudes9.Card{ honour: 2, suit: :spade },
                                 %Etudes9.Card{ honour: 2, suit: :diamond },
                                 %Etudes9.Card{ honour: 5, suit: :spade },
                                 %Etudes9.Card{ honour: 4, suit: :spade }])
    player1 = Etudes9.create_player()
    player2 = Etudes9.create_player()
    Etudes9.Deck.deal(deck, [player1, player2])
    Etudes9.Deck.play_round([player1, player2])
    collected1 = Etudes9.Deck.collect([player1])
    collected2 = Etudes9.Deck.collect([player2])
    assert Enum.count(collected1.cards) == 4
    assert Enum.count(collected2.cards) == 0
    # Logger.info "Collected cards: #{inspect collected1.cards}."
    [ card1, card2, card3, card4 ] = collected1 .cards
    assert card1 == %Etudes9.Card{ honour: 2, suit: :spade}
    assert card2 == %Etudes9.Card{ honour: 2, suit: :diamond}
    assert card3 == %Etudes9.Card{ honour: 5, suit: :spade}
    assert card4 == %Etudes9.Card{ honour: 4, suit: :spade}
  end

  test "round - same card drawn twice" do
    deck = Etudes9.Deck.create([ %Etudes9.Card{ honour: 2, suit: :spade },
                                 %Etudes9.Card{ honour: 2, suit: :diamond },
                                 %Etudes9.Card{ honour: 9, suit: :heart },
                                 %Etudes9.Card{ honour: 9, suit: :club },
                                 %Etudes9.Card{ honour: 7, suit: :spade },
                                 %Etudes9.Card{ honour: 8, suit: :spade }])
    player1 = Etudes9.create_player()
    player2 = Etudes9.create_player()
    Etudes9.Deck.deal(deck, [player1, player2])
    Etudes9.Deck.play_round([player1, player2])
    collected1 = Etudes9.Deck.collect([player1])
    collected2 = Etudes9.Deck.collect([player2])
    assert Enum.count(collected1.cards) == 0
    assert Enum.count(collected2.cards) == 6
    # Logger.info "Collected cards: #{inspect collected1.cards}."
    [ card1, card2, card3, card4, card5, card6 ] = collected2.cards
    assert card1 == %Etudes9.Card{ honour: 2, suit: :spade}
    assert card2 == %Etudes9.Card{ honour: 2, suit: :diamond}
    assert card3 == %Etudes9.Card{ honour: 9, suit: :heart}
    assert card4 == %Etudes9.Card{ honour: 9, suit: :club}
    assert card5 == %Etudes9.Card{ honour: 7, suit: :spade}
    assert card6 == %Etudes9.Card{ honour: 8, suit: :spade}
  end

  test "round - too few cards" do
    deck = Etudes9.Deck.create([ %Etudes9.Card{ honour: 2, suit: :spade },
                                 %Etudes9.Card{ honour: 2, suit: :diamond },
                                 %Etudes9.Card{ honour: 9, suit: :heart },
                                 %Etudes9.Card{ honour: 9, suit: :club },
                                 %Etudes9.Card{ honour: 7, suit: :spade }])
    player1 = Etudes9.create_player()
    player2 = Etudes9.create_player()
    Etudes9.Deck.deal(deck, [player1, player2])
    Etudes9.Deck.play_round([player1, player2])
    collected1 = Etudes9.Deck.collect([player1])
    collected2 = Etudes9.Deck.collect([player2])
    assert Enum.count(collected1.cards) == 5
    assert Enum.count(collected2.cards) == 0
    # Logger.info "Collected cards: #{inspect collected1.cards}."
    [ card1, card2, card3, card4, card5 ] = collected1.cards
    assert card1 == %Etudes9.Card{ honour: 2, suit: :spade}
    assert card2 == %Etudes9.Card{ honour: 2, suit: :diamond}
    assert card3 == %Etudes9.Card{ honour: 9, suit: :heart}
    assert card4 == %Etudes9.Card{ honour: 9, suit: :club}
    assert card5 == %Etudes9.Card{ honour: 7, suit: :spade}
  end

  test "basic 2-round scenario to find out proper deck rolling" do
    deck = Etudes9.Deck.create([ %Etudes9.Card{ honour: 2, suit: :spade },
                                 %Etudes9.Card{ honour: 3, suit: :spade },
                                 %Etudes9.Card{ honour: 5, suit: :spade },
                                 %Etudes9.Card{ honour: 5, suit: :club },
                                 %Etudes9.Card{ honour: 7, suit: :club }])
    player1 = Etudes9.create_player()
    player2 = Etudes9.create_player()
    Etudes9.Deck.deal(deck, [player1, player2])
    Etudes9.Deck.play_round([player1, player2])
    Etudes9.Deck.play_round([player1, player2])
    collected1 = Etudes9.Deck.collect([player1])
    collected2 = Etudes9.Deck.collect([player2])
    assert Enum.count(collected1.cards) == 4
    assert Enum.count(collected2.cards) == 1
    [ card1, card2, card3, card4 ] = collected1.cards
    assert card1 == %Etudes9.Card{ honour: 5, suit: :spade}
    assert card2 == %Etudes9.Card{ honour: 5, suit: :club}
    assert card3 == %Etudes9.Card{ honour: 7, suit: :club}
    assert card4 == %Etudes9.Card{ honour: 2, suit: :spade}
    [ card5 ] = collected2.cards
    assert card5 == %Etudes9.Card{ honour: 3, suit: :spade}
  end

  test "round - victory conditions mets" do
    deck = Etudes9.Deck.create([ %Etudes9.Card{ honour: 2, suit: :spade },
                                 %Etudes9.Card{ honour: 3, suit: :spade },
                                 %Etudes9.Card{ honour: 4, suit: :spade },
                                 %Etudes9.Card{ honour: 5, suit: :spade }])
    player1 = Etudes9.create_player()
    player2 = Etudes9.create_player()
    players0 = [player1, player2]
    Etudes9.Deck.deal(deck, players0)
    Etudes9.Deck.play_round(players0)
    players1 = Etudes9.Deck.check_victory_conditions(players0)
    assert players1 == [player1,player2]
    Etudes9.Deck.play_round(players1)
    players2 = Etudes9.Deck.check_victory_conditions(players1)
    assert players2 == [player2]
  end

end
