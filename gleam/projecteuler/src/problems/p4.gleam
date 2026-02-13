import gleam/int
import gleam/list
import utilities/timing

pub fn main() {
  timing.run(solution)
}

fn solution() {
  use acc, n <- list.fold(int.range(100, 1000, [], list.prepend), 0)
  use acc, m <- list.fold(int.range(n, 1000, [], list.prepend), acc)
  case is_palindrome(n * m) {
    True -> int.max(acc, n * m)
    False -> acc
  }
}

fn is_palindrome(n) {
  n == do_reverse(n, 0)
}

fn do_reverse(n, acc) {
  case n {
    0 -> acc
    n -> do_reverse(n / 10, acc * 10 + n % 10)
  }
}
