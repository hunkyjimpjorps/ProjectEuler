import gleam/int
import gleam/list
import gleam/string
import simplifile
import splitter
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

const roman = [
  "CM", "M", "CD", "D", "XC", "C", "XL", "L", "IX", "X", "IV", "V", "I",
]

fn to_value(str) {
  case str {
    "CM" -> 900
    "M" -> 1000
    "CD" -> 400
    "D" -> 500
    "XC" -> 90
    "C" -> 100
    "XL" -> 40
    "L" -> 50
    "IX" -> 9
    "X" -> 10
    "IV" -> 4
    "V" -> 5
    "I" -> 1
    _ -> panic
  }
}

fn solution() {
  let digit_parser = splitter.new(roman)

  let rewriter_table =
    roman
    |> list.map(fn(s) { #(to_value(s), s) })
    |> list.sort(fn(tup1, tup2) { int.compare(tup2.0, tup1.0) })

  let assert Ok(ns) = simplifile.read("data/89.txt")
  let ns = string.split(ns, "\n")

  list.fold(ns, 0, fn(acc, n) {
    let val = get_value(n, 0, digit_parser)
    let rewritten = rewrite(rewriter_table, val, "")
    acc + string.length(n) - string.length(rewritten)
  })
}

fn get_value(str, acc, splitter) {
  case splitter.split_after(splitter, str) {
    #("", "") -> acc
    #(digit, rest) -> get_value(rest, acc + to_value(digit), splitter)
  }
}

fn rewrite(table, n, acc) {
  case table {
    [] -> acc
    [#(val, sym), ..rest] -> {
      case n >= val {
        True -> rewrite(table, n - val, acc <> sym)
        False -> rewrite(rest, n, acc)
      }
    }
  }
}
