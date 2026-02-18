import gleam/bool
import gleam/int
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  use acc, p <- int.range(2, 1001, #(0, 0))
  use <- bool.guard(int.is_odd(p), acc)
  case acc, count_pythagorean_triples(p) {
    #(_, old_n), n if n >= old_n -> #(p, n)
    _, _ -> acc
  }
}

fn count_pythagorean_triples(p) {
  use acc, a <- int.range(1, p / 3, 0)
  use acc, b <- int.range(a, p / 2, acc)
  let c = p - a - b
  case a * a + b * b == c * c {
    True -> acc + 1
    False -> acc
  }
}
