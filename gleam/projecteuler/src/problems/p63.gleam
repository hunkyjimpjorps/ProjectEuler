import gleam/list
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> Int {
  count_powers(1)
}

fn count_powers(digits: Int) -> Int {
  let pows = powers_in_range(digits)
  case pows {
    [] -> 0
    _ -> list.length(pows) + count_powers(digits + 1)
  }
}

fn powers_in_range(digits: Int) -> List(Int) {
  do_powers(1, digits, math.pow(10, digits - 1), math.pow(10, digits) - 1, [])
}

fn do_powers(
  n: Int,
  digits: Int,
  from: Int,
  to: Int,
  acc: List(Int),
) -> List(Int) {
  let pow = math.pow(n, digits)
  case from <= pow, pow <= to {
    False, _ -> do_powers(n + 1, digits, from, to, acc)
    _, False -> acc
    _, _ -> do_powers(n + 1, digits, from, to, [pow, ..acc])
  }
}
