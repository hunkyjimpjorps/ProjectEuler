import gleam/int
import gleam/list.{Continue, Stop}
import gleam/string
import gleam/yielder
import gleam_community/maths
import simplifile
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  let assert Ok(encoded) = simplifile.read("./data/59.txt")

  let original =
    list.map(string.split(encoded, ","), fn(byte) {
      let assert Ok(n) = int.parse(byte)
      n
    })

  let range = int.range(97, 123, [], list.prepend) |> list.reverse
  let assert Ok(keys) = maths.list_permutation_with_repetitions(range, 3)

  use acc, key <- yielder.fold_until(keys, 0)
  let trial =
    try_key(original, key)
    |> yielder.to_list
    |> string.from_utf_codepoints
  case string.contains(trial, "found") {
    False -> Continue(acc)
    True ->
      trial
      |> string.to_utf_codepoints
      |> list.map(string.utf_codepoint_to_int)
      |> int.sum
      |> Stop
  }
}

fn try_key(original, key) {
  let apply = key |> yielder.from_list |> yielder.cycle

  original
  |> yielder.from_list
  |> yielder.zip(apply)
  |> yielder.filter_map(fn(zip) {
    int.bitwise_exclusive_or(zip.0, zip.1) |> string.utf_codepoint
  })
}
