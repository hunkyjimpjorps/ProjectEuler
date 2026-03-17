import utilities/fraction.{type Fraction, Fraction}
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

const limit: Int = 1_000_000

fn solution() -> Fraction {
  find_best_denominator(limit)
}

fn find_best_denominator(den: Int) -> Fraction {
  let trial = fraction.simplify(Fraction(3 * den - 1, 7 * den))
  case trial.den <= limit {
    True -> trial
    False -> find_best_denominator(den - 1)
  }
}
