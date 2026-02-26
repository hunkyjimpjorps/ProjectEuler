import gleam/int
import gleam/list
import gleam/set
import utilities/digits
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  use acc, n <- int.range(1, 1_000_000, 0)
  case find_loop(n, 0, set.new()) {
    60 -> acc + 1
    _ -> acc
  }
}

fn digit_factorial(n) {
  case n {
    0 -> 1
    1 -> 1
    2 -> 2
    3 -> 6
    4 -> 24
    5 -> 120
    6 -> 720
    7 -> 5040
    8 -> 40_320
    9 -> 362_880
    _ -> panic
  }
}

fn transform(n) {
  let assert Ok(digits) = digits.to_digits(n, 10)
  list.fold(digits, 0, fn(acc, d) { acc + digit_factorial(d) })
}

fn find_loop(n, count, seen) {
  case set.contains(seen, n) {
    _ if count > 60 -> 61
    True -> count
    False -> find_loop(transform(n), count + 1, set.insert(seen, n))
  }
}
