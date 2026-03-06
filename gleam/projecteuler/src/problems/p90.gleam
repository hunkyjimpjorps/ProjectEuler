import gleam/bool
import gleam/list
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

const squares = [
  #(0, 1),
  #(0, 4),
  #(0, 9),
  #(1, 6),
  #(2, 5),
  #(3, 6),
  #(4, 9),
  #(6, 4),
  #(8, 1),
]

const digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

fn solution() {
  list.combinations(digits, 6)
  |> list.combination_pairs
  |> list.count(valid_set)
}

fn valid_set(dice) {
  let #(first, second) = dice
  let all_pairs = {
    use f <- list.flat_map(first)
    use s <- list.flat_map(second)
    case f, s {
      6, 6 | 6, 9 | 9, 9 | 9, 6 -> [#(6, 6), #(6, 9), #(9, 9), #(6, 6)]
      6, _ | 9, _ -> [#(6, s), #(9, s), #(s, 6), #(s, 9)]
      _, 6 | _, 9 -> [#(6, f), #(9, f), #(f, 6), #(f, 9)]
      _, _ -> [#(s, f), #(f, s)]
    }
  }

  list.any(squares, fn(s) { !list.contains(all_pairs, s) })
  |> bool.negate
}
