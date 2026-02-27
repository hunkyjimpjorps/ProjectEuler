import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/string
import simplifile
import splitter
import tote/bag
import utilities/digits
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  let assert Ok(data) = simplifile.read("./data/98.txt")

  let pairs = parse(data)
  let squares_dict = build_squares(9, 1) |> list.group(digits.number_of_digits)

  list.filter_map(pairs, fn(pair) {
    let assert [word1, word2] = pair
    let assert Ok(squares) = dict.get(squares_dict, string.length(word1))
    check_pair(string.to_graphemes(word1), string.to_graphemes(word2), squares)
  })
  |> list.max(int.compare)
}

fn parse(str) {
  let split_on = splitter.new({ ["\",\"", "\""] })

  do_parse(str, [], split_on)
  |> list.group(grouper)
  |> dict.filter(fn(_, v) { list.length(v) > 1 })
  |> dict.values
  |> list.flat_map(list.window(_, 2))
}

fn do_parse(str, acc, splitter) {
  case splitter.split(splitter, str) {
    #("", _, rest) -> do_parse(rest, acc, splitter)
    #(name, _, "") -> list.reverse([name, ..acc])
    #(name, _, rest) -> do_parse(rest, [name, ..acc], splitter)
  }
}

fn grouper(str) {
  str |> string.to_graphemes |> bag.from_list
}

fn build_squares(n, i) {
  let square = i * i
  case digits.number_of_digits(square) > n {
    True -> []
    False -> [square, ..build_squares(n, i + 1)]
  }
}

fn check_pair(word1, word2, squares) {
  case squares {
    [] -> Error(Nil)
    [square, ..rest] -> {
      let eject = fn() { check_pair(word1, word2, rest) }

      let assert Ok(ds) = digits.to_digits(square, 10)
      let transform = list.zip(word1, ds) |> dict.from_list
      use <- bool.lazy_guard(unique_pairings(transform), eject)

      let rearranged_digits = list.filter_map(word2, dict.get(transform, _))
      use <- bool.lazy_guard(list.first(rearranged_digits) == Ok(0), eject)

      case list.filter_map(word2, dict.get(transform, _)) {
        [0, ..] -> check_pair(word1, word2, rest)
        digits -> {
          let assert Ok(trial_square) = digits.from_digits(digits, 10)
          case math.exact_square_root(trial_square) {
            Ok(..) -> Ok(int.max(square, trial_square))
            Error(..) -> check_pair(word1, word2, rest)
          }
        }
      }
    }
  }
}

fn unique_pairings(dict) {
  let vals = dict.values(dict)
  list.unique(vals) != vals
}
