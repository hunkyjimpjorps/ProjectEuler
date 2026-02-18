import gleam/int
import gleam/list
import utilities/digits
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  has_permuted_multiples(1)
}

fn has_permuted_multiples(n) {
  let multiples =
    [1, 2, 3, 4, 5, 6]
    |> list.map(fn(int) {
      let assert Ok(digits) = digits.to_digits(n * int, 10)
      digits |> list.sort(int.compare)
    })
    |> list.unique

  case multiples {
    [_] -> n
    _ -> has_permuted_multiples(n + 1)
  }
}
