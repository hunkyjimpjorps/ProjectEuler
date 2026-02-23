import gleam/int
import rememo/memo
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  use cache <- memo.create()
  find_partitions(100, 100, cache) - 1
}

fn find_partitions(n, goal, cache) {
  use <- memo.memoize(cache, #(n, goal))
  case n {
    0 -> 0
    1 -> 1
    n -> {
      let partitions =
        math.step_range(1, goal, 1, 0, fn(acc, x) {
          acc + find_partitions(n - x, int.min(n - x, x), cache)
        })
      case n <= goal {
        True -> partitions + 1
        False -> partitions
      }
    }
  }
}
