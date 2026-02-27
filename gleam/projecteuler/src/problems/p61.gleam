// incomplete

import gleam/dict
import gleam/list
import utilities/timing

type Figurate {
  Triangle
  Square
  Pentagonal
  Hexagonal
  Heptagonal
  Octagonal
}

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  generate_shape_numbers(3, dict.new()) |> dict.size
}

fn generate_shape_numbers(n, acc) {
  case n * { n + 1 } / 2 > 9999 {
    True -> acc
    False -> {
      [
        #(n * { n + 1 } / 2, Triangle),
        #(n * n, Square),
        #(n * { 3 * n - 1 } / 2, Pentagonal),
        #(n * { 2 * n - 1 }, Hexagonal),
        #(n * { 5 * n - 3 } / 2, Heptagonal),
        #(n * { 3 * n - 2 }, Octagonal),
      ]
      |> list.filter(fn(n) { n.0 >= 1000 && n.0 <= 9999 })
      |> dict.from_list
      |> dict.combine(acc, fn(_, b) { b })
      |> generate_shape_numbers(n + 1, _)
    }
  }
}
