import gleam/int
import utilities/primes
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> Int {
  primes.up_to(1_000_000) |> int.sum
}
