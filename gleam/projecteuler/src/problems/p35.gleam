import gleam/bool
import gleam/int
import gleam/list
import gleam/result
import gleam_community/maths
import problems/p10
import utilities/digits
import utilities/timing

pub fn main() -> Nil {
  let primes = p10.primes_up_to(1_000_000)
  timing.run(fn() { solution(primes) })
}

fn solution(primes) {
  list.count(primes, is_circular_prime)
}

fn is_circular_prime(n) {
  let assert Ok(digits) = digits.to_digits(n, 10)
  use <- bool.guard(list.any(digits, is_bad_digit) && n > 10, False)
  int.range(0, list.length(digits), [], fn(acc, n) {
    list.drop(digits, n)
    |> list.append(list.take(digits, n))
    |> digits.from_digits(10)
    |> result.unwrap(0)
    |> list.prepend(acc, _)
  })
  |> list.all(maths.is_prime)
}

fn is_bad_digit(n) {
  case n {
    2 | 4 | 5 | 6 | 8 -> True
    _ -> False
  }
}
