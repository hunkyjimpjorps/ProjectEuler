import gleam/float
import gleam/int
import gleam/list
import gleam/set
import gleam/string
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0]
  |> list.combinations(4)
  |> list.fold(#("", 0.0), fn(acc, xs) {
    let max_representable = find_max_representable(xs)
    case max_representable >. acc.1 {
      True -> #(to_string(xs), max_representable)
      False -> acc
    }
  })
}

fn find_max_representable(xs) {
  xs
  |> list.permutations
  |> list.flat_map(do_all_ops)
  |> set.from_list
  |> find_gap(0.0)
}

fn do_all_ops(xs) {
  case xs {
    [a] -> [a]
    [a, b, ..rest] ->
      list.flat_map(do_ops(a, b), fn(x) { do_all_ops([x, ..rest]) })
    [] -> []
  }
}

fn find_gap(set, i) {
  case set.contains(set, i +. 1.0) {
    True -> find_gap(set, i +. 1.0)
    False -> i
  }
}

fn do_ops(a, b) {
  case a, b {
    _, 0.0 -> [a, 0.0]
    0.0, _ -> [b, 0.0 -. b, 0.0]
    _, _ -> [a +. b, b -. a, a -. b, a *. b, a /. b, b /. a]
  }
}

fn to_string(xs) {
  list.map(xs, fn(x) { float.round(x) |> int.to_string }) |> string.concat
}
