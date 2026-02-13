import gleam/bool
import gleam/yielder
import utilities/timing

pub fn main() {
  timing.run(solution)
}

fn solution() {
  prime(10_001)
}

pub fn prime(number: Int) -> Result(Int, Nil) {
  use <- bool.guard(number <= 0, Error(Nil))
  yielder.single(2)
  |> yielder.append(yielder.iterate(3, fn(n) { n + 2 }))
  |> yielder.filter(is_prime(_, 3))
  |> yielder.at(number - 1)
}

fn is_prime(n: Int, k: Int) -> Bool {
  use <- bool.guard(n == 2, True)
  use <- bool.guard(n < k * k, True)
  use <- bool.guard(n % k == 0, False)
  is_prime(n, k + 2)
}
