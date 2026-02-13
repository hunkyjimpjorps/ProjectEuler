import gleam/list
import gleam_community/maths
import utilities/timing

pub fn main() {
  timing.run(solution)
}

fn solution() {
  600_851_475_143
  |> maths.proper_divisors
  |> list.reverse
  |> list.find(maths.is_prime)
}
