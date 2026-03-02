import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/set
import gleam_community/maths
import utilities/math
import utilities/primes
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

const limit = 50_000_000

fn solution() {
  let square_limit = math.floor_square_root(limit)
  let assert Ok(cube_limit) =
    maths.nth_root(int.to_float(limit), 3) |> result.map(float.truncate)
  let assert Ok(quartic_limit) =
    maths.nth_root(int.to_float(limit), 4) |> result.map(float.truncate)

  let primes = primes.up_to(square_limit)

  let sum_set = {
    use acc, a <- list.fold(primes, set.new())
    use acc, b <- list.fold(below(primes, cube_limit), acc)
    use acc, c <- list.fold(below(primes, quartic_limit), acc)
    let sum = a * a + b * b * b + c * c * c * c
    case sum < limit {
      True -> set.insert(acc, sum)
      False -> acc
    }
  }

  set.size(sum_set)
}

fn below(xs, n) {
  list.take_while(xs, fn(p) { p < n })
}
