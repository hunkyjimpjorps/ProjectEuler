import gleam/int
import gleam/pair
import utilities/timing

pub fn main() {
  timing.run(solution)
}

fn solution() {
  int.range(1, 1_000_000, #(1, 1), fn(acc, n) {
    let #(_, best_collatz) = acc
    let trial_collatz = collatz(n)
    case trial_collatz > best_collatz {
      True -> #(n, trial_collatz)
      False -> acc
    }
  })
  |> pair.first
}

fn collatz(n) {
  case n {
    1 -> 0
    n if n % 2 == 0 -> 1 + collatz(n / 2)
    n -> 1 + collatz(3 * n + 1)
  }
}
