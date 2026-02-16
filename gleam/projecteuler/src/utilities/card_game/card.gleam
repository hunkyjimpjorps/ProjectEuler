import gleam/int
import gleam/order

pub type Card {
  Card(suit: Suit, rank: Rank)
}

pub type Suit {
  Spade
  Heart
  Club
  Diamond
}

pub type Rank {
  Ace
  King
  Queen
  Jack
  Number(rank: Int)
}

pub fn to_value(rank: Rank) -> Int {
  case rank {
    Ace -> 14
    King -> 13
    Queen -> 12
    Jack -> 11
    Number(n) -> n
  }
}

pub fn to_card(chars: List(String)) -> Result(Card, Nil) {
  let assert [rank, suit] = chars
  let suit = to_suit(suit)
  case rank {
    "A" -> Ok(Card(suit, Ace))
    "K" -> Ok(Card(suit, King))
    "Q" -> Ok(Card(suit, Queen))
    "J" -> Ok(Card(suit, Jack))
    "T" -> Ok(Card(suit, Number(10)))
    n -> {
      let assert Ok(n) = int.parse(n)
      Ok(Card(suit, Number(n)))
    }
  }
}

fn to_suit(suit: String) -> Suit {
  case suit {
    "S" -> Spade
    "H" -> Heart
    "C" -> Club
    "D" -> Diamond
    _ -> panic
  }
}

pub fn compare(rank1, rank2) {
  int.compare(to_value(rank1), to_value(rank2))
}

pub fn compare_lists(ranks1, ranks2) {
  case ranks1, ranks2 {
    [], [] -> order.Eq
    [c1, ..], [c2, ..] if c1 != c2 -> compare(c1, c2)
    [_, ..c1s], [_, ..c2s] -> compare_lists(c1s, c2s)
    _, _ -> panic
  }
}
