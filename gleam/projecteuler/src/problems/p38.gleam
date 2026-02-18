import gleam/bool
import gleam/int
import gleam/list
import utilities/digits
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  use acc, n <- int.range(9000, 10_000, 0)
  case make_pandigital(n) {
    Ok(p) -> int.max(p, acc)
    _ -> acc
  }
}

fn make_pandigital(n) {
  do_pandigital(n, 1, [])
}

fn do_pandigital(n, i, acc) {
  let assert Ok(next_product) = { n * i } |> digits.to_digits(10)
  use <- bool.guard(list.contains(next_product, 0), Error(Nil))
  use <- bool.guard(next_product != list.unique(next_product), Error(Nil))
  use <- bool.guard(list.any(next_product, list.contains(acc, _)), Error(Nil))
  let acc = list.append(acc, next_product)
  case list.length(acc) {
    9 -> acc |> digits.from_digits(10)
    _ -> do_pandigital(n, i + 1, acc)
  }
}
