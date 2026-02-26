import gleam/int
import gleam/list
import gleam/set.{type Set}

pub fn up_to(upper_bound: Int) -> List(Int) {
  case upper_bound {
    l if l <= 1 -> []
    2 -> [2]
    l ->
      range_step(from: 3, to: l, step: 2)
      |> do_primes_up_to(3, l, set.from_list([2]))
      |> set.to_list
      |> list.sort(int.compare)
  }
}

fn do_primes_up_to(
  candidates: Set(Int),
  i: Int,
  limit: Int,
  acc: Set(Int),
) -> Set(Int) {
  case i * i <= limit {
    False -> set.union(acc, candidates)
    True ->
      case set.contains(candidates, i) {
        False -> do_primes_up_to(candidates, i + 2, limit, acc)
        True -> {
          candidates
          |> set.delete(i)
          |> set.difference(range_step(from: i * i, to: limit, step: 2 * i))
          |> do_primes_up_to(i + 2, limit, set.insert(acc, i))
        }
      }
  }
}

fn range_step(from from: Int, to to: Int, step step: Int) -> Set(Int) {
  do_range_step(to, step, [from])
}

fn do_range_step(to: Int, step: Int, acc: List(Int)) -> Set(Int) {
  let assert [h, ..] = acc
  case h + step <= to {
    True -> do_range_step(to, step, [h + step, ..acc])
    False -> set.from_list(acc)
  }
}
