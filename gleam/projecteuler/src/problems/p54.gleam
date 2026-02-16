import gleam/list
import gleam/order
import gleam/string
import simplifile
import utilities/card_game/card
import utilities/card_game/poker_hand
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  let assert Ok(raw_cards) = simplifile.read("./data/54.txt")

  raw_cards
  |> string.trim
  |> string.split("\n")
  |> list.count(fn(line) {
    let cards =
      line
      |> string.split(" ")
      |> list.filter_map(fn(c) {
        c
        |> string.to_graphemes
        |> card.to_card
      })
      |> list.sized_chunk(5)
      |> list.map(poker_hand.classify)

    let assert [left, right] = cards
    { poker_hand.compare(left, right) == order.Gt }
  })
}
