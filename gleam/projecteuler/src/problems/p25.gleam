import utilities/digits
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> Int {
  fib(1, 1, 3)
}

fn fib(n1: Int, n2: Int, i: Int) -> Int {
  let n3 = n1 + n2
  case digits.number_of_digits(n3) {
    1000 -> i
    _ -> fib(n2, n3, i + 1)
  }
}
