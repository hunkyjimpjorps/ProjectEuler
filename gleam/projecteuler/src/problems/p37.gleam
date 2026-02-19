import gleam/int
import gleam/list
import gleam_community/maths
import utilities/digits
import utilities/math
import utilities/primes
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  primes.up_to(1_000_000)
  |> list.drop_while(fn(p) { p < 10 })
  |> list.filter(is_truncatable_prime)
  |> int.sum
}

fn is_truncatable_prime(n) {
  list.append(truncate_left(n), truncate_right(n))
  |> list.all(maths.is_prime)
}

fn truncate_left(n) {
  case n {
    n if n < 10 -> []
    n -> {
      let len = math.pow(10, digits.number_of_digits(n) - 1)
      [n % len, ..truncate_left(n % len)]
    }
  }
}

fn truncate_right(n) {
  case n {
    n if n < 10 -> []
    n -> [n / 10, ..truncate_right(n / 10)]
  }
}
