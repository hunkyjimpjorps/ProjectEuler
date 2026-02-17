import gleam/int
import gleam/list
import gleam/set
import utilities/digits
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  int.range(1, 1000, set.new(), fn(acc, n) {
    let #(even, odd) = make_palindromes(n)
    acc |> set.insert(even) |> set.insert(odd)
  })
  |> set.fold(0, fn(acc, p) {
    case is_double_palindrome(p) {
      True -> p + acc
      False -> acc
    }
  })
}

fn is_double_palindrome(n) {
  let assert Ok(binary) = digits.to_digits(n, 2)
  binary == list.reverse(binary)
}

fn make_palindromes(n) {
  let len = math.pow(10, number_of_digits(n) - 1)
  let suffix = digits.reverse(n)
  #(n * { len * 10 } + suffix, n * len + suffix % len)
}

fn number_of_digits(n) {
  case n {
    0 -> 0
    n -> 1 + number_of_digits(n / 10)
  }
}
