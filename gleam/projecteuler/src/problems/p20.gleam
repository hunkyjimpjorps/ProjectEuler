import gleam/int
import gleam/result
import gleam_community/maths
import utilities/digits
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  let assert Ok(n) = maths.factorial(100)
  n |> digits.to_digits(10) |> result.map(int.sum)
}
