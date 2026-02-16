import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/order
import gleam/pair
import utilities/card_game/card.{
  type Card, type Rank, Ace, Jack, King, Number, Queen,
}

pub type Hand {
  RoyalFlush
  StraightFlush(high_card: Rank)
  FourOfAKind(match: Rank, rest: List(Rank))
  FullHouse(big: Rank, small: Rank)
  Flush(cards: List(Rank))
  Straight(high_card: Rank)
  ThreeOfAKind(match: Rank, rest: List(Rank))
  TwoPair(big: Rank, small: Rank, rest: Rank)
  OnePair(match: Rank, rest: List(Rank))
  HighCard(cards: List(Rank))
}

pub fn to_rank(hand: Hand) -> Int {
  case hand {
    RoyalFlush -> 10
    StraightFlush(..) -> 9
    FourOfAKind(..) -> 8
    FullHouse(..) -> 7
    Flush(..) -> 6
    Straight(..) -> 5
    ThreeOfAKind(..) -> 4
    TwoPair(..) -> 3
    OnePair(..) -> 2
    HighCard(..) -> 1
  }
}

pub fn compare(hand1, hand2) {
  use <- bool.guard(
    to_rank(hand1) != to_rank(hand2),
    int.compare(to_rank(hand1), to_rank(hand2)),
  )
  case hand1, hand2 {
    StraightFlush(h1), StraightFlush(h2) | Straight(h1), Straight(h2) ->
      card.compare(h1, h2)
    FullHouse(h1, l1), FullHouse(h2, l2) ->
      card.compare_lists([h1, l1], [h2, l2])
    FourOfAKind(f1, c1), FourOfAKind(f2, c2)
    | ThreeOfAKind(f1, c1), ThreeOfAKind(f2, c2)
    | OnePair(f1, c1), OnePair(f2, c2)
    -> card.compare_lists([f1, ..c1], [f2, ..c2])
    Flush(c1), Flush(c2) | HighCard(c1), HighCard(c2) ->
      card.compare_lists(c1, c2)
    TwoPair(h1, l1, c1), TwoPair(h2, l2, c2) ->
      card.compare_lists([h1, l1, c1], [h2, l2, c2])
    _, _ -> panic
  }
}

pub fn classify(cards: List(Card)) {
  let bag =
    cards
    |> list.group(fn(c) { c.rank })
    |> dict.to_list
    |> list.map(fn(tup) { #(tup.0, list.length(tup.1)) })
    |> list.sort(fn(tup1, tup2) {
      order.break_tie(int.compare(tup2.1, tup1.1), card.compare(tup2.0, tup1.0))
    })

  let is_flush = is_flush(cards)
  let is_straight = is_straight(list.map(bag, pair.first))
  case bag {
    [#(Ace, 1), #(King, 1), #(Queen, 1), #(Jack, 1), #(Number(10), 1)] ->
      RoyalFlush
    [#(c, 1), ..] if is_flush && is_straight -> StraightFlush(c)
    [#(match, 4), #(other, 1)] -> FourOfAKind(match, [other])
    [#(big, 3), #(small, 2)] -> FullHouse(big, small)
    _ if is_flush -> Flush(get_cards(bag))
    [#(c, 1), ..] if is_straight -> Straight(c)
    [#(match, 3), ..rest] -> ThreeOfAKind(match, get_cards(rest))
    [#(high, 2), #(low, 2), #(rest, 1)] -> TwoPair(high, low, rest)
    [#(match, 2), ..rest] -> OnePair(match, get_cards(rest))
    other -> HighCard(get_cards(other))
  }
}

fn is_flush(hand: List(Card)) {
  case hand {
    [_] -> True
    [c1, c2, ..rest] if c1.suit == c2.suit -> is_flush([c2, ..rest])
    _ -> False
  }
}

fn is_straight(hand: List(Rank)) {
  case hand {
    [_] -> True
    [c1, c2, ..rest] ->
      case card.to_value(c1) - card.to_value(c2) {
        1 -> is_straight([c2, ..rest])
        _ -> False
      }
    _ -> False
  }
}

fn get_cards(bag) {
  list.map(bag, pair.first)
}
