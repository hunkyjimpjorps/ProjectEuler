import gleam/list
import gleam/set
import rememo/memo
import utilities/timing

pub fn main() {
  timing.run(solution)
}

fn solution() {
  use cache <- memo.create()
  find_four_by_four(1, cache)
}

fn find_four_by_four(n: Int, cache) {
  case [n, n + 1, n + 2, n + 3] |> list.map(count_factors(_, cache)) {
    [4, 4, 4, 4] -> n
    _ -> find_four_by_four(n + 1, cache)
  }
}

fn count_factors(n, cache) {
  use <- memo.memoize(cache, n)
  do_factorize(n, 2, set.new()) |> set.size
}

fn do_factorize(n, d, acc) {
  case n {
    1 -> acc
    n if n % d == 0 -> do_factorize(n / d, d, set.insert(acc, d))
    n -> do_factorize(n, d + 1, acc)
  }
}
