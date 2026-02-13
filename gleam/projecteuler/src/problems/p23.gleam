import gleam/int
import gleam/list
import gleam/set
import gleam_community/maths
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  let abundants = {
    use acc, n <- int.range(1, 28_124, [])
    case n < int.sum(maths.proper_divisors(n)) {
      True -> [n, ..acc]
      False -> acc
    }
  }

  let abundant_sums =
    {
      use a <- list.flat_map(abundants)
      use b <- list.map(abundants)
      a + b
    }
    |> set.from_list

  int.range(1, 28_124, set.new(), set.insert)
  |> set.difference(abundant_sums)
  |> set.fold(0, int.add)
}
