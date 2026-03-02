import gleam/dict
import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/set
import gleam_community/maths
import rememo/memo
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  let aliquots =
    int.range(1, 1_000_000, dict.new(), fn(acc, n) {
      dict.insert(acc, n, aliquot(n))
    })

  use acc, n <- int.range(100_000, 0, #(0, 0))
  let next_aliquot = aliquot(n)
  case next_aliquot < n {
    True -> acc
    False -> {
      let result = find_chain(next_aliquot, set.from_list([n]), n, aliquots)
      case result > acc.1 {
        True -> #(n, result)
        False -> acc
      }
    }
  }
}

fn aliquot(n) {
  int.sum(maths.proper_divisors(n))
}

fn find_chain(n: Int, seen, first, dict) {
  let aliquot = dict.get(dict, n)
  let contains = result.map(aliquot, set.contains(seen, _))
  case aliquot, contains {
    Ok(aliquot), _ if aliquot == first -> set.size(seen) + 1
    Ok(aliquot), Ok(False) if aliquot < first -> 0
    Ok(aliquot), Ok(False) ->
      find_chain(aliquot, set.insert(seen, n), first, dict)
    _, Ok(True) | Error(..), _ | _, Error(..) -> 0
  }
}
