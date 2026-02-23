import utilities/fraction.{Fraction}
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

const limit = 1_000_000

fn solution() {
  find_best_denominator(limit)
}

fn find_best_denominator(den: Int) {
  let trial = fraction.simplify(Fraction(3 * den - 1, 7 * den))
  case trial.den <= limit {
    True -> trial
    False -> find_best_denominator(den - 1)
  }
}
