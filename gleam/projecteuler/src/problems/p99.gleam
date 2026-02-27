import gleam/int
import gleam/list
import gleam/string
import gleam_community/maths
import simplifile
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  let assert Ok(data) = simplifile.read("./data/99.txt")

  use acc, line, i <- list.index_fold(string.split(data, "\n"), #(0, 0.0))
  echo string.split(line, ",")
  let assert [b, n] =
    string.split(line, ",")
    |> list.filter_map(int.parse)
    |> list.map(int.to_float)
  let assert Ok(log) = maths.logarithm_10(b)
  case n *. log >. acc.1 {
    True -> #(i + 1, n *. log)
    False -> acc
  }
}
