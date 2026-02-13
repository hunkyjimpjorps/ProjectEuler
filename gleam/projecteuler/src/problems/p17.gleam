import gleam/int
import gleam/result
import gleam/string
import utilities/digits
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  use acc, n <- int.range(1, 1001, 0)
  acc + { result.unwrap(echo to_words(n), "") |> string.length }
}

fn to_words(n: Int) {
  case digits.digits(n, 10) {
    Error(_) -> Error(Nil)
    Ok(digits) ->
      case digits {
        [o] -> ones(o)
        [1, o] -> special_two_digit(10 + o)
        [t, 0] -> tens(t)
        [t, o] -> merge(tens(t), ones(o))
        [h, 0, 0] -> ones(h) |> merge(Ok("hundred"))
        [h, t, o] ->
          ones(h)
          |> merge(Ok("hundredand"))
          |> merge(to_words(10 * t + o))
        [1, 0, 0, 0] -> Ok("onethousand")
        _ -> Error(Nil)
      }
  }
}

fn ones(int: Int) -> Result(String, Nil) {
  case int {
    1 -> Ok("one")
    2 -> Ok("two")
    3 -> Ok("three")
    4 -> Ok("four")
    5 -> Ok("five")
    6 -> Ok("six")
    7 -> Ok("seven")
    8 -> Ok("eight")
    9 -> Ok("nine")
    _ -> Error(Nil)
  }
}

fn tens(int: Int) -> Result(String, Nil) {
  case int {
    2 -> Ok("twenty")
    3 -> Ok("thirty")
    4 -> Ok("forty")
    5 -> Ok("fifty")
    6 -> Ok("sixty")
    7 -> Ok("seventy")
    8 -> Ok("eighty")
    9 -> Ok("ninety")
    _ -> Error(Nil)
  }
}

fn special_two_digit(int: Int) -> Result(String, Nil) {
  case int {
    10 -> Ok("ten")
    11 -> Ok("eleven")
    12 -> Ok("twelve")
    13 -> Ok("thirteen")
    14 -> Ok("fourteen")
    15 -> Ok("fifteen")
    16 -> Ok("sixteen")
    17 -> Ok("seventeen")
    18 -> Ok("eighteen")
    19 -> Ok("nineteen")
    _ -> Error(Nil)
  }
}

fn merge(str1, str2) {
  case str1, str2 {
    Ok(s1), Ok(s2) -> Ok(s1 <> s2)
    _, _ -> Error(Nil)
  }
}
