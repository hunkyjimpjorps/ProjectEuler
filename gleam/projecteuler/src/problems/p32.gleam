import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam_community/maths
import utilities/digits
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  use acc, n <- int.range(1, 10_000, 0)
  case has_pandigital_product(n) {
    True -> n + acc
    False -> acc
  }
}

fn has_pandigital_product(n) {
  let assert Ok(limit) = int.square_root(n) |> result.map(float.round)

  list.any(maths.proper_divisors(n), fn(d) {
    d <= limit && is_pandigital(d, n / d, n)
  })
}

fn is_pandigital(d1, d2, n) {
  let digits =
    [d1, d2, n] |> list.filter_map(digits.to_digits(_, 10)) |> list.flatten

  list.sort(digits, int.compare) == [1, 2, 3, 4, 5, 6, 7, 8, 9]
}
