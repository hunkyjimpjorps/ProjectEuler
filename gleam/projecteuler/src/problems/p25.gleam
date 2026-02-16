import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  fib(1, 1, 3)
}

fn fib(n1, n2, i) {
  let n3 = n1 + n2
  case number_of_digits(n3, 0) {
    1000 -> i
    _ -> fib(n2, n3, i + 1)
  }
}

fn number_of_digits(n, acc) {
  case n {
    0 -> acc
    n -> number_of_digits(n / 10, acc + 1)
  }
}
