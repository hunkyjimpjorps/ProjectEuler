import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/result
import utilities/timing

type Figurate {
  Triangle
  Square
  Pentagonal
  Hexagonal
  Heptagonal
  Octagonal
}

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> Result(Int, Nil) {
  let shape_dict = generate_shape_numbers(3, dict.new())
  let shape_numbers = dict.keys(shape_dict)

  let suffix_dict =
    list.map(shape_numbers, fn(n) {
      #(n, list.filter(shape_numbers, fn(m) { n % 100 == m / 100 }))
    })
    |> dict.from_list
    |> dict.filter(fn(_, v) { !list.is_empty(v) })

  list.find_map(dict.keys(suffix_dict), fn(k) {
    let loop = find_loop(k, k, suffix_dict, [])
    case is_valid_loop(loop, shape_dict) {
      True -> result.map(loop, int.sum)
      False -> Error(Nil)
    }
  })
}

fn generate_shape_numbers(
  n: Int,
  acc: Dict(Int, Figurate),
) -> Dict(Int, Figurate) {
  case n * { n + 1 } / 2 > 9999 {
    True -> acc
    False -> {
      [
        #(n * { n + 1 } / 2, Triangle),
        #(n * n, Square),
        #(n * { 3 * n - 1 } / 2, Pentagonal),
        #(n * { 2 * n - 1 }, Hexagonal),
        #(n * { 5 * n - 3 } / 2, Heptagonal),
        #(n * { 3 * n - 2 }, Octagonal),
      ]
      |> list.filter(fn(n) { n.0 >= 1000 && n.0 <= 9999 })
      |> dict.from_list
      |> dict.combine(acc, fn(_, b) { b })
      |> generate_shape_numbers(n + 1, _)
    }
  }
}

fn find_loop(
  current: Int,
  start: Int,
  dict: Dict(Int, List(Int)),
  seen: List(Int),
) -> Result(List(Int), Nil) {
  case seen {
    [_, _, _, _, _, _] if current == start -> Ok(seen)
    [_, _, _, _, _, _, ..] -> Error(Nil)
    _ ->
      case dict.get(dict, current) {
        Ok(vs) ->
          list.fold(vs, Error(Nil), fn(acc, v) {
            let result = find_loop(v, start, dict, [current, ..seen])
            result.or(result, acc)
          })
        Error(Nil) -> Error(Nil)
      }
  }
}

fn is_valid_loop(xs: Result(List(a), b), dict: Dict(a, c)) -> Bool {
  let shapes = result.map(xs, list.filter_map(_, dict.get(dict, _)))

  case shapes {
    Ok(s) -> list.unique(s) == s
    _ -> False
  }
}
