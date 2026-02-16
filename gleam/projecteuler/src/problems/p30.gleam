import gleam/int
import gleam/list
import utilities/digits
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  use acc, n <- int.range(2, 6 * math.pow(9, 5), 0)
  let assert Ok(digits) = digits.to_digits(n, 10)
  let sum = digits |> list.map(math.pow(_, 5)) |> int.sum
  case n == sum {
    True -> n + acc
    False -> acc
  }
}
