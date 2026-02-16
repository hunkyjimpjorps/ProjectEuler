import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  let coins =
    [1, 2, 5, 10, 20, 50, 100, 200]
    |> list.index_map(fn(c, i) { #(i + 1, c) })
    |> dict.from_list
  let sum = 200
  let dict = dict.new() |> dict.insert(#(0, 0), 1)

  let dp = {
    use acc, coin_index <- int.range(1, dict.size(coins) + 1, dict)
    use acc, value <- int.range(0, sum + 1, acc)

    let assert Ok(coin_value) = dict.get(coins, coin_index)
    let difference = value - coin_value
    let added_ways = case difference >= 0 {
      False -> 0
      True -> dict.get(acc, #(coin_index, difference)) |> result.unwrap(0)
    }

    acc
    |> dict.get(#(coin_index - 1, value))
    |> result.unwrap(0)
    |> int.add(added_ways)
    |> dict.insert(acc, #(coin_index, value), _)
  }

  dict.get(dp, #(dict.size(coins), sum))
}
