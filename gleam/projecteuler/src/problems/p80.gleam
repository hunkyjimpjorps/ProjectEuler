import gleam/int
import gleam/list
import gleam/result
import utilities/digits
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  use acc, n <- int.range(1, 100, 0)
  case math.exact_square_root(n) {
    Ok(..) -> acc
    Error(..) -> acc + expansion_sum(n)
  }
}

fn expansion_sum(n) {
  let s = n * math.pow(10, 200)
  heron(s, s / 2)
  |> digits.to_digits(10)
  |> result.map(list.take(_, 100))
  |> result.map(int.sum)
  |> result.unwrap(0)
}

fn heron(n, x0) {
  let x1 = { x0 + n / x0 } / 2
  case x0 == x1 {
    True -> x1
    False -> heron(n, x1)
  }
}
