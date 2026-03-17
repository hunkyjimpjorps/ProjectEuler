import gleam/dict.{type Dict}
import gleam/list
import gleam/option
import gleam/set.{type Set}
import gleam/string
import simplifile
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> String {
  let assert Ok(entries) = simplifile.read("./data/79.txt")

  list.fold(string.split(entries, "\n"), dict.new(), fn(acc, codes) {
    let assert [a, b, c] = string.to_graphemes(codes)
    acc
    |> dict.upsert(a, option.unwrap(_, set.new()))
    |> dict.upsert(b, fn(v) { option.unwrap(v, set.new()) |> set.insert(a) })
    |> dict.upsert(c, fn(v) { option.unwrap(v, set.new()) |> set.insert(b) })
  })
  |> assemble_passcode("")
}

fn assemble_passcode(dict: Dict(String, Set(String)), acc: String) -> String {
  case dict.is_empty(dict) {
    True -> acc
    False -> {
      let assert [#(next, _)] =
        dict.filter(dict, fn(_, v) { set.is_empty(v) }) |> dict.to_list

      dict
      |> dict.delete(next)
      |> dict.map_values(fn(_, v) { set.delete(v, next) })
      |> assemble_passcode(acc <> next)
    }
  }
}
