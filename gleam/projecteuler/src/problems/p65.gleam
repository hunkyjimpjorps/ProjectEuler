import gleam/int
import gleam/pair
import gleam/result
import gleam/yielder
import utilities/continued_fraction
import utilities/digits
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  yielder.iterate(1, int.add(_, 1))
  |> yielder.map(fn(n) { yielder.from_list([1, 2 * n, 1]) })
  |> yielder.flatten()
  |> yielder.prepend(2)
  |> yielder.take(100)
  |> yielder.to_list
  |> continued_fraction.to_rational
  |> pair.first
  |> digits.digits(10)
  |> result.map(int.sum)
}
