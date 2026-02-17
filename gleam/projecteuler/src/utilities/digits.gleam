import gleam/int

pub fn to_digits(x: Int, base: Int) -> Result(List(Int), Nil) {
  case base < 2 {
    True -> Error(Nil)
    False -> Ok(digits_loop(x, base, []))
  }
}

fn digits_loop(x: Int, base: Int, acc: List(Int)) -> List(Int) {
  case int.absolute_value(x) < base {
    True -> [x, ..acc]
    False -> digits_loop(x / base, base, [x % base, ..acc])
  }
}

pub fn undigits(numbers: List(Int), base: Int) -> Result(Int, Nil) {
  case base < 2 {
    True -> Error(Nil)
    False -> undigits_loop(numbers, base, 0)
  }
}

fn undigits_loop(numbers: List(Int), base: Int, acc: Int) -> Result(Int, Nil) {
  case numbers {
    [] -> Ok(acc)
    [digit, ..] if digit >= base -> Error(Nil)
    [digit, ..rest] -> undigits_loop(rest, base, acc * base + digit)
  }
}

pub fn reverse(n: Int) -> Int {
  do_reverse(n, 0)
}

fn do_reverse(n: Int, acc: Int) -> Int {
  case n {
    0 -> acc
    n -> do_reverse(n / 10, acc * 10 + n % 10)
  }
}

pub fn number_of_digits(n) {
  case n {
    0 -> 0
    n -> 1 + number_of_digits(n / 10)
  }
}
