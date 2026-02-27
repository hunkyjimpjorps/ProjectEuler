import gleam/dict
import gleam/int
import gleam/list
import gleam/string
import tote/bag
import utilities/shortcut

type Draw {
  Draw(fn(Int) -> Int)
}

import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> String {
  let squares = special_squares_dict()

  traverse(0, 0, squares, bag.new(), 5_000_000)
  |> bag.to_list
  |> list.sort(fn(tup1, tup2) { int.compare(tup2.1, tup1.1) })
  |> list.take(3)
  |> list.map(fn(tup) { int.to_string(tup.0) })
  |> string.concat
}

fn special_squares_dict() -> dict.Dict(Int, Draw) {
  int.range(0, 40, dict.new(), fn(acc, i) {
    dict.insert(acc, i, Draw(fn(n) { n }))
  })
  |> dict.insert(30, Draw(fn(_) { 10 }))
  |> dict.insert(2, Draw(handle_community))
  |> dict.insert(17, Draw(handle_community))
  |> dict.insert(7, Draw(handle_chance))
  |> dict.insert(22, Draw(handle_chance))
  |> dict.insert(36, Draw(handle_chance))
}

fn handle_community(current: Int) -> Int {
  case int.random(16) {
    0 -> 0
    1 -> 10
    _ -> current
  }
}

fn handle_chance(current: Int) -> Int {
  case int.random(16) {
    0 -> 0
    1 -> 10
    2 -> 11
    3 -> 24
    4 -> 39
    5 -> 5
    6 | 7 ->
      case current {
        7 -> 15
        22 -> 25
        36 -> 5
        _ -> panic
      }
    8 ->
      case current {
        7 | 36 -> 12
        22 -> 28
        _ -> panic
      }
    9 -> current - 3
    _ -> current
  }
}

fn roll_dice() -> #(Int, Int) {
  #(int.random(4) + 1, int.random(4) + 1)
}

fn traverse(
  current_square: Int,
  doubles: Int,
  sqs: dict.Dict(Int, Draw),
  acc: bag.Bag(Int),
  i: Int,
) -> bag.Bag(Int) {
  let #(a, b) = roll_dice()
  let next_square = { current_square + a + b } % 40
  let doubles = shortcut.ternary(a == b, doubles + 1, 0)

  case dict.get(sqs, next_square), doubles {
    _, _ if i == 0 -> acc
    _, 3 -> traverse(10, 0, sqs, bag.insert(acc, 1, 10), i - 1)
    Ok(Draw(f)), _ -> {
      case f(next_square), doubles {
        10, _ -> traverse(10, 0, sqs, bag.insert(acc, 1, 10), i - 1)
        other, 0 -> traverse(other, 0, sqs, bag.insert(acc, 1, other), i - 1)
        other, _ -> traverse(other, doubles + 1, sqs, acc, i)
      }
    }
    Error(_), _ -> panic
  }
}
