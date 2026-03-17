import gleam/int
import gleam/list
import gleam_community/maths
import rememo/memo.{type Cache}
import utilities/math
import utilities/primes
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> #(Int, Int) {
  let primes = primes.up_to(1000)
  use cache <- memo.create()
  use n <- math.step_to_find(10, 1)
  case find_partitions(n, n, primes, cache) {
    parts if parts > 5000 -> Ok(parts)
    _ -> Error(Nil)
  }
}

fn find_partitions(
  n: Int,
  goal: Int,
  primes: List(Int),
  cache: Cache(#(Int, Int), Int),
) -> Int {
  use <- memo.memoize(cache, #(n, goal))
  case n {
    0 | 1 -> 0
    2 -> 1
    n -> {
      let partitions =
        list.fold(list.take_while(primes, fn(p) { p <= goal }), 0, fn(acc, x) {
          acc + find_partitions(n - x, int.min(n - x, x), primes, cache)
        })
      case n <= goal && maths.is_prime(n) {
        True -> partitions + 1
        False -> partitions
      }
    }
  }
}
