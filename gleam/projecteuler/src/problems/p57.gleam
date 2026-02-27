import gleam/bool
import utilities/digits
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  do_recurrence([1, 1], [1, 0], 0, 1000)
}

fn do_recurrence(a: List(Int), b: List(Int), acc: Int, count: Int) {
  use <- bool.guard(count == 0, acc)

  let assert [an1, an2, ..] = a
  let assert [bn1, bn2, ..] = b

  let an = 2 * an1 + an2
  let bn = 2 * bn1 + bn2
  let acc = case digits.number_of_digits(an) > digits.number_of_digits(bn) {
    True -> acc + 1
    False -> acc
  }
  do_recurrence([an, ..a], [bn, ..b], acc, count - 1)
}
