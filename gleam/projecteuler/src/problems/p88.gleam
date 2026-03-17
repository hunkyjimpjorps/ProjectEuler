import booklet.{type Booklet}
import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/set
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

const max_size: Int = 12_000

fn solution() -> Int {
  let cache = booklet.new(dict.new())
  int.range(1, 2 * max_size + 1, 0, fn(_, i) { get_min_k(i, cache) })

  booklet.get(cache)
  |> dict.delete(1)
  |> dict.values
  |> set.from_list
  |> set.fold(0, int.add)
}

fn get_min_k(i: Int, cache: Booklet(Dict(Int, Int))) -> Int {
  do_get_min_k(i, i, i, 1, 2, cache)
}

fn do_get_min_k(
  n: Int,
  product: Int,
  sum: Int,
  depth: Int,
  min_factor: Int,
  cache: Booklet(Dict(Int, Int)),
) -> Int {
  use <- bool.lazy_guard(product == 1, fn() { valid(n, depth + sum - 1, cache) })
  use <- bool.lazy_guard(depth > 1 && product == sum, fn() {
    valid(n, depth, cache)
  })
  let result = case depth > 1 {
    True -> valid(n, depth + sum - product, cache)
    False -> 0
  }

  use acc, i <- int.range(
    min_factor,
    math.floor_square_root(product) + 1,
    result,
  )
  case product % i == 0 {
    True -> acc + do_get_min_k(n, product / i, sum - i, depth + 1, i, cache)
    False -> acc
  }
}

fn valid(n: Int, k: Int, cache: Booklet(Dict(Int, Int))) -> Int {
  use <- bool.guard(k > max_size, 0)
  let _ = case cache |> booklet.get() |> dict.get(k) {
    Ok(prev_n) if prev_n <= n -> 0
    _ -> {
      booklet.update(cache, dict.insert(_, k, n))
      1
    }
  }
}
