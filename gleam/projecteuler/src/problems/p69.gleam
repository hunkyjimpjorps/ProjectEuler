import gleam/dict.{type Dict}
import gleam/int
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  math.step_range(2, 1_000_000, 1, dict.new(), fn(acc, n) {
    dict.insert(acc, n, n)
  })
  |> compute_totients(2, 1_000_000)
  |> dict.fold(#(0, 0.0), fn(max, k, v) {
    let div = int.to_float(k) /. int.to_float(v)
    case max.1 <. div {
      True -> #(k, div)
      False -> max
    }
  })
}

fn compute_totients(totients: Dict(Int, Int), i: Int, limit: Int) {
  case i == limit {
    True -> totients
    False ->
      case dict.get(totients, i) == Ok(i) {
        True -> {
          let updated_totients =
            math.step_range(i, limit, i, totients, fn(acc, j) {
              let assert Ok(t) = dict.get(acc, j)
              dict.insert(acc, j, t - t / i)
            })
          compute_totients(updated_totients, i + 1, limit)
        }
        False -> compute_totients(totients, i + 1, limit)
      }
  }
}
