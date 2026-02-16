import gleam/int
import gleam/list
import utilities/continued_fraction
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> Int {
  use acc, n <- int.range(from: 1, to: 10_000, with: 0)
  case has_odd_period(n) {
    True -> acc + 1
    False -> acc
  }
}

fn has_odd_period(n: Int) -> Bool {
  n |> continued_fraction.find |> list.length |> int.is_even
}
