import gleam/list
import gleam_community/maths
import utilities/digits
import utilities/primes
import utilities/timing

const all_digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

pub fn main() {
  timing.run(solution)
}

fn solution() {
  let assert Ok(#(_, digits)) =
    primes.up_to(999_999)
    |> list.drop_while(fn(p) { p < 100_000 })
    |> list.filter_map(find_replaceable_digits)
    |> list.find(does_form_prime_family)
  digits.from_digits(digits, 10)
}

fn does_form_prime_family(tup) {
  let #(to_replace, digits) = tup
  let primes_in_family =
    {
      use a <- list.map(all_digits)
      use d <- list.map(digits)
      case d == to_replace {
        True -> a
        False -> d
      }
    }
    |> list.filter(fn(ds) { list.first(ds) != Ok(0) })
    |> list.count(fn(ds) {
      let assert Ok(n) = digits.from_digits(ds, 10)
      maths.is_prime(n)
    })
  primes_in_family >= 8
}

fn find_replaceable_digits(p) {
  let assert Ok(digits) = digits.to_digits(p, 10)
  let result =
    [0, 1, 2]
    |> list.find(fn(n) { list.count(digits, fn(d) { d == n }) == 3 })
  case result {
    Ok(n) -> Ok(#(n, digits))
    Error(_) -> Error(Nil)
  }
}
