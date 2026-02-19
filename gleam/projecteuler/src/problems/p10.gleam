import gleam/int
import utilities/primes
import utilities/timing

pub fn main() {
  timing.run(solution)
}

fn solution() {
  primes.up_to(1_000_000) |> int.sum
}
