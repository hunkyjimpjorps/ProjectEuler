import gleam/int
import gleam_community/maths
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  use acc, n <- int.range(1, 101, 0)
  use acc, r <- int.range(1, n + 1, acc)
  let assert Ok(c) = maths.combination(n, r)
  case c > 1_000_000 {
    True -> acc + 1
    False -> acc
  }
}
