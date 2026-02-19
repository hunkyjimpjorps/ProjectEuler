import gleam/dict
import gleam/int
import gleam/list
import utilities/digits
import utilities/primes
import utilities/timing

pub fn main() {
  timing.run(solution)
}

fn solution() {
  primes.up_to(9999)
  |> list.drop_while(fn(n) { n < 1000 })
  |> list.group(fn(n) {
    let assert Ok(digits) = digits.to_digits(n, 10)
    list.sort(digits, int.compare)
  })
  |> dict.values
  |> list.flat_map(fn(primes) {
    primes |> list.combinations(3) |> list.map(list.sort(_, int.compare))
  })
  |> list.filter_map(fn(primes) {
    let assert [p1, p2, p3] = primes
    case p2 - p1 == p3 - p2 {
      True ->
        primes
        |> list.filter_map(digits.to_digits(_, 10))
        |> list.flatten
        |> digits.from_digits(10)
      False -> Error(Nil)
    }
  })
}
