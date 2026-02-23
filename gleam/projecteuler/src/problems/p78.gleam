import rememo/memo
import utilities/math
import utilities/shortcut
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

// One of Ramanujan's congruences is that p(5k + 4) = 0 (mod 5), 
// so we only need to check n that end in 4 or 9

fn solution() {
  use cache <- memo.create()
  math.step_until(4, 5, fn(n) {
    let partitions = find_partitions(n, cache)
    case partitions % 1_000_000 {
      0 -> Ok(partitions)
      _ -> Error(Nil)
    }
  })
}

fn find_partitions(n, cache) {
  use <- memo.memoize(cache, n)
  case n {
    0 -> 1
    neg if neg < 0 -> 0
    n -> do_recurrence(n, 1, 0, cache)
  }
}

// From https://oeis.org/A000041

fn do_recurrence(n, k, acc, cache) {
  let left = find_partitions(n - k * { 3 * k - 1 } / 2, cache)
  let right = find_partitions(n - k * { 3 * k + 1 } / 2, cache)
  let sign = shortcut.ternary(k % 2 == 1, 1, -1)
  case left, right {
    0, 0 -> acc
    l, r -> do_recurrence(n, k + 1, acc + sign * { l + r }, cache)
  }
}
