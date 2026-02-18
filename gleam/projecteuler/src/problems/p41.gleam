import gleam/yielder
import gleam_community/maths
import utilities/digits
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

// All 8- and 9-digit pandigital numbers are composite because they're divisible by 3
// (since the sums of their digits are also divisible by 3), so the largest pandigital 
// prime number has seven digits

fn solution() {
  let assert Ok(digits) = maths.list_permutation([7, 6, 5, 4, 3, 2, 1], 7)
  yielder.find_map(digits, fn(xs) {
    let assert Ok(n) = digits.from_digits(xs, 10)
    case maths.is_prime(n) {
      True -> Ok(n)
      False -> Error(Nil)
    }
  })
}
