import gleam/int
import utilities/digits
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  use acc, a <- int.range(1, 100, 0)
  use acc, b <- int.range(1, 100, acc)
  let assert Ok(digits) = math.pow(a, b) |> digits.to_digits(10)
  int.max(acc, int.sum(digits))
}
