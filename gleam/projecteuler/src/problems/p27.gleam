import gleam/int
import gleam/list
import gleam_community/maths
import utilities/primes
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  let best = {
    use acc, b <- list.fold(primes.up_to(1000), #(0, 0, 0))
    use acc, a <- int.range(-b + 1, 1000, acc)
    let f = poly(_, a, b)
    let count = count_primes(f)
    case count > acc.2 {
      True -> #(a, b, count)
      False -> acc
    }
  }
  best.0 * best.1
}

fn poly(n, a, b) {
  n * n + a * n + b
}

fn count_primes(f) {
  do_count_primes(f, 0)
}

fn do_count_primes(f, n) {
  case maths.is_prime(f(n)) {
    True -> do_count_primes(f, n + 1)
    False -> n
  }
}
