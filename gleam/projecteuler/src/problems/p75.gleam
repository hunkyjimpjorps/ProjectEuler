import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/set
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

const max: Int = 1_500_000

fn solution() -> Int {
  {
    use acc, m <- int.range(2, math.floor_square_root(max) + 1, dict.new())
    use acc, n <- math.fold_while(1, m, 1, acc)
    let sides =
      list.sort([m * m - n * n, 2 * m * n, m * m + n * n], int.compare)
    let perimeter = int.sum(sides)
    case perimeter > max {
      True -> Error(Nil)
      False ->
        all_valid_multiples(1, perimeter, sides)
        |> list.fold(acc, fn(acc, m) {
          dict.upsert(acc, m.0, fn(v) {
            set.insert(option.unwrap(v, set.new()), m.1)
          })
        })
        |> Ok
    }
  }
  |> dict.filter(fn(_, v) { set.size(v) == 1 })
  |> dict.size
}

fn all_valid_multiples(
  k: Int,
  length: Int,
  sides: List(Int),
) -> List(#(Int, List(Int))) {
  case k * length > max {
    True -> []
    False -> [
      #(k * length, list.map(sides, int.multiply(_, k))),
      ..all_valid_multiples(k + 1, length, sides)
    ]
  }
}
