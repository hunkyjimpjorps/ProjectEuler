import gleam/int
import gleam/list
import rememo/memo
import utilities/digits
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  use cache <- memo.create()
  use acc, i <- int.range(1, 10_000_000, 0)
  case digit_chain(i, cache) {
    Ok(_) -> acc + 1
    Error(_) -> acc
  }
}

fn digit_chain(n, cache) {
  case n {
    1 -> Error(Nil)
    89 -> Ok(Nil)
    _ -> {
      let assert Ok(digits) = digits.to_digits(n, 10)
      use <- memo.memoize(cache, list.sort(digits, int.compare))
      digits |> list.map(math.pow(_, 2)) |> int.sum |> digit_chain(cache)
    }
  }
}
