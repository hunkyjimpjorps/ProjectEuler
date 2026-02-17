import gleam/int
import gleam/list
import gleam/yielder
import gleam_community/maths
import utilities/digits
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

const all_digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

fn solution() {
  use acc, n <- int.range(2, 6, 0)
  let assert Ok(digit_yielder) =
    maths.list_combination_with_repetitions(all_digits, n)

  yielder.filter_map(digit_yielder, fn(xs) {
    let sum = xs |> list.filter_map(maths.factorial) |> int.sum
    let assert Ok(sum_digits) = digits.to_digits(sum, 10)
    case list.sort(sum_digits, int.compare) == list.sort(xs, int.compare) {
      True -> Ok(sum)
      False -> Error(Nil)
    }
  })
  |> yielder.fold(acc, int.add)
}
