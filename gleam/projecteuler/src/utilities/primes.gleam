import gleam/int
import gleam/list
import gleam/set.{type Set}

pub fn up_to(upper_bound: Int) -> List(Int) {
  case upper_bound {
    l if l <= 1 -> []
    2 -> [2]
    l ->
      range_step(from: 3, to: l, step: 2)
      |> do_primes_up_to(3, l, [2])
      |> list.sort(int.compare)
  }
}

fn do_primes_up_to(
  candidates: Set(Int),
  pointer: Int,
  limit: Int,
  acc: List(Int),
) -> List(Int) {
  case set.contains(candidates, pointer), pointer * pointer <= limit {
    _, False -> list.append(acc, set.to_list(candidates))
    False, _ -> do_primes_up_to(candidates, pointer + 2, limit, acc)
    True, True -> {
      let removed =
        range_step(from: pointer * pointer, to: limit, step: 2 * pointer)
      let sieved = candidates |> set.delete(pointer) |> set.difference(removed)
      do_primes_up_to(sieved, pointer + 2, limit, [pointer, ..acc])
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
