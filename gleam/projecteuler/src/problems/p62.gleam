import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option
import utilities/digits
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> Int {
  find_permutable_cube(1, dict.new())
}

fn find_permutable_cube(n: Int, acc: Dict(List(Int), List(Int))) -> Int {
  let cube = n * n * n
  let assert Ok(cube_digits) = digits.to_digits(cube, 10)
  let sorted = list.sort(cube_digits, int.compare)

  case dict.get(acc, sorted) {
    Ok([_, _, _, smallest]) -> smallest
    _ ->
      acc
      |> dict.upsert(sorted, fn(v) { [cube, ..option.unwrap(v, [])] })
      |> find_permutable_cube(n + 1, _)
  }
}
