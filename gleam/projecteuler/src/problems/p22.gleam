import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile
import splitter
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn parse(str) {
  let split_on = splitter.new({ ["\",\"", "\""] })

  do_parse(str, [], split_on)
  |> list.sort(string.compare)
  |> list.index_map(fn(name, i) { #(i, name) })
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
  int.range(1, 27, dict.new(), fn(acc, i) {
    let assert Ok(c) = string.utf_codepoint(i + a)
    dict.insert(acc, [c] |> string.from_utf_codepoints, i)
  })
}

fn solution() {
  let assert Ok(data) = simplifile.read("./data/22.txt")
  let scores = letter_scores()

  use acc, pair <- list.fold(parse(data), 0)
  let #(i, name) = pair
  let score =
    name
    |> string.to_graphemes
    |> list.filter_map(dict.get(scores, _))
    |> int.sum
  acc + score * i
}
