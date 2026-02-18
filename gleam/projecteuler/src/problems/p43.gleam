import gleam/list
import gleam/yielder
import gleam_community/maths
import utilities/digits
import utilities/timing

const digits = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]

const divisors = [1, 2, 3, 5, 7, 11, 13, 17]

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  let assert Ok(ns) = maths.list_permutation(digits, 10)
  yielder.filter(ns, is_special)
  |> yielder.fold(0, fn(acc, xs) {
    let assert Ok(n) = digits.from_digits(xs, 10)
    acc + n
  })
}

fn is_special(digits) {
  digits
  |> list.window(3)
  |> list.map2(divisors, fn(xs, d) {
    let assert Ok(n) = digits.from_digits(xs, 10)
    n % d
  })
  |> list.all(fn(n) { n == 0 })
}
