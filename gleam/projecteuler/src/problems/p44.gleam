import gleam/int
import gleam/list
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> Int {
  find_pair(1)
}

fn find_pair(k: Int) -> Int {
  let p_k = pentagonal(k)

  let result =
    int.range(k - 1, 0, [], list.prepend)
    |> list.find_map(fn(j) {
      let p_j = pentagonal(j)

      case is_pentagonal(p_k - p_j) && is_pentagonal(p_k + p_j) {
        True -> Ok(p_k - p_j)
        False -> Error(Nil)
      }
    })

  case result {
    Ok(result) -> result
    Error(_) -> find_pair(k + 1)
  }
}

fn pentagonal(n: Int) -> Int {
  n * { 3 * n - 1 } / 2
}

fn is_pentagonal(n: Int) -> Bool {
  case math.square_root(24 * n + 1) {
    Ok(n) -> { 1 + n } % 6 == 0
    Error(_) -> False
  }
}
