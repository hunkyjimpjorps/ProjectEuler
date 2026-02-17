import gleam/bool
import gleam/int
import utilities/digits
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  use acc, n <- int.range(1, 10_000, 0)
  case is_lychrel(n) {
    True -> acc + 1
    False -> acc
  }
}

fn is_lychrel(n) {
  do_lychrel(n + digits.reverse(n), 0)
}

fn do_lychrel(n, i) {
  use <- bool.guard(i == 50, True)
  let rev = digits.reverse(n)
  use <- bool.guard(n == rev, False)
  do_lychrel(n + rev, i + 1)
}
