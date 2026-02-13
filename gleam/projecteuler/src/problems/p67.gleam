import gleam/int
import gleam/list
import gleam/string
import simplifile
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  let assert Ok(raw_pyramid) = simplifile.read("./data/67.txt")
  raw_pyramid |> string.trim |> parse |> find_best_path
}

fn parse(input) {
  input
  |> string.split("\n")
  |> list.map(fn(row) { row |> string.split(" ") |> list.filter_map(int.parse) })
  |> list.reverse
}

fn find_best_path(pyramid) {
  case pyramid {
    [[best]] -> best
    [this_row, next_row, ..rest] -> {
      this_row
      |> list.window(2)
      |> list.filter_map(list.max(_, int.compare))
      |> list.map2(next_row, int.add)
      |> list.prepend(rest, _)
      |> find_best_path()
    }
    _ -> panic
  }
}
