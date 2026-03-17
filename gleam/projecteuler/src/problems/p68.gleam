import gleam/int
import gleam/list
import gleam/order
import gleam/string
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> Result(String, Nil) {
  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  |> list.permutations
  |> list.filter_map(valid_fivegon)
  |> list.sort(order.reverse(string.compare))
  |> list.first
}

fn valid_fivegon(fivegon: List(Int)) -> Result(String, Nil) {
  let assert [a, b, c, d, e, f, g, h, i, j] = fivegon

  let line1 = a + b + c
  let line2 = c + d + e
  let line3 = e + f + g
  let line4 = g + h + i
  let line5 = i + j + b

  let order_compatible = a < d && a < f && a < h && a < j
  let sums_compatible =
    list.all([line1, line2, line3, line4, line5], fn(l) { l == line1 })

  case order_compatible && sums_compatible {
    True -> {
      let str =
        [a, b, c, d, c, e, f, e, g, h, g, i, j, i, b]
        |> list.map(int.to_string)
        |> string.concat
      case string.length(str) {
        16 -> Ok(str)
        _ -> Error(Nil)
      }
    }
    False -> Error(Nil)
  }
}
