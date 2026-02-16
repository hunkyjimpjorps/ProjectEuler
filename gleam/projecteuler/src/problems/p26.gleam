import gleam/bool
import gleam/int
import gleam_community/maths
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  use acc, n <- int.range(1, 1000, #(1, 0))
  let len = multiplicative_order(10, n)
  case len {
    Error(Nil) -> acc
    Ok(l) if l > acc.1 -> #(n, l)
    _ -> acc
  }
}

fn multiplicative_order(a, m) {
  use <- bool.guard(maths.gcd(a, m) != 1 || m == 1, Error(Nil))
  do_ord(a, m, 1, 1) |> Ok
}

fn do_ord(a, m, k, acc) {
  let acc = { a * acc } % m
  case acc {
    1 -> k
    _ -> do_ord(a, m, k + 1, acc)
  }
}
