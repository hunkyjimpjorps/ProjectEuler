import gleam/bool
import gleam/int
import gleam/set
import gleam_community/maths
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  int.range(2, 10_000, set.new(), find_amicable_numbers)
  |> set.fold(0, int.add)

  maths.divisors(0)
}

fn find_amicable_numbers(acc, n) {
  use <- bool.guard(set.contains(acc, n), acc)
  let m = n |> maths.proper_divisors |> int.sum
  use <- bool.guard(n == m, acc)
  let trial_n = m |> maths.proper_divisors |> int.sum
  case n == trial_n {
    True -> acc |> set.insert(echo n) |> set.insert(echo m)
    False -> acc
  }
}
