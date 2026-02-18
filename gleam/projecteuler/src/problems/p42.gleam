import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile
import splitter
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  let assert Ok(data) = simplifile.read("./data/42.txt")
  let scores = letter_scores()

  use acc, name <- list.fold(parse(data), 0)
  let score =
    name
    |> string.to_graphemes
    |> list.filter_map(dict.get(scores, _))
    |> int.sum

  case math.square_root(8 * score + 1) {
    Ok(_) -> acc + 1
    Error(_) -> acc
  }
}

fn parse(str) {
  let split_on = splitter.new({ ["\",\"", "\""] })

  do_parse(str, [], split_on)
}

fn do_parse(str, acc, splitter) {
  case splitter.split(splitter, str) {
    #("", _, rest) -> do_parse(rest, acc, splitter)
    #(name, _, "") -> list.reverse([name, ..acc])
    #(name, _, rest) -> do_parse(rest, [name, ..acc], splitter)
  }
}

fn letter_scores() {
  let assert Ok(a) =
    string.to_utf_codepoints("A")
    |> list.first
    |> result.map(string.utf_codepoint_to_int)
  int.range(0, 26, dict.new(), fn(acc, i) {
    let assert Ok(c) = string.utf_codepoint(i + a)
    dict.insert(acc, [c] |> string.from_utf_codepoints, i + 1)
  })
}
