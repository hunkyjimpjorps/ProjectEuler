import gleam/int
import gleam/yielder
import utilities/digits
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  let champernowne =
    yielder.repeat(Nil)
    |> yielder.transform(1, fn(i, _el) {
      let assert Ok(xs) = digits.to_digits(i, 10)
      yielder.Next(yielder.from_list(xs), i + 1)
    })
    |> yielder.flatten

  int.range(0, 7, 1, fn(acc, n) {
    let assert Ok(d) = yielder.at(champernowne, math.pow(10, n) - 1)
    acc * d
  })
}
