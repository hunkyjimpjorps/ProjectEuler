import gleam/int
import gleam/result
import utilities/digits
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  pow(2, 1000) |> digits.digits(10) |> result.map(int.sum)
}

fn pow(x: Int, n: Int) -> Int {
  case n {
    0 -> 1
    n if n % 2 == 0 -> {
      let a = pow(x, n / 2)
      a * a
    }
    n -> x * pow(x, n - 1)
  }
}
