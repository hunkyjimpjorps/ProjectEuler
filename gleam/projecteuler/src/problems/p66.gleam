import gleam/int
import gleam/list
import gleam/pair
import utilities/continued_fraction
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> #(Int, Int) {
  use acc, n <- int.range(from: 1, to: 1000, with: #(0, 0))
  let x = get_x(n)
  case x > acc.1 {
    True -> #(n, x)
    False -> acc
  }
}

fn get_x(n: Int) -> Int {
  n
  |> continued_fraction.find
  |> fundamental_pell_solution
  |> continued_fraction.to_rational
  |> pair.first
}

fn fundamental_pell_solution(list: List(Int)) -> List(Int) {
  let assert [head, ..period] = list
  let assert Ok(truncated) = period |> list.reverse |> list.rest
  case int.is_even(list.length(period)) {
    True -> [head, ..truncated]
    False -> [head, ..period] |> list.append(truncated)
  }
}
