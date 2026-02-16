import gleam/bool
import gleam/int
import utilities/fraction.{type Fraction, Fraction}
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> Fraction {
  use acc, a <- int.range(1, 10, Fraction(1, 1))
  use acc, b <- int.range(1, 10, acc)
  use acc, c <- int.range(1, 10, acc)
  use <- bool.guard(a == c, acc)
  let trial_frac = Fraction(10 * a + b, 10 * b + c)
  case fraction.is_equal(trial_frac, Fraction(a, c)) {
    True -> fraction.multiply(trial_frac, acc)
    False -> acc
  }
}
