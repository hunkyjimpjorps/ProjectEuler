import gleam/bool
import gleam/int
import gleam/result
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  find_cuboids(1, 0)
}

const max = 1_000_000

fn find_cuboids(a, count) {
  let new_count =
    int.range(1, 2 * a + 1, count, fn(acc, b_plus_c) {
      case shortest_path_is_integer(a, b_plus_c), b_plus_c <= a + 1 {
        True, True -> acc + b_plus_c / 2
        True, _ -> acc + { 2 * a - b_plus_c + 2 } / 2
        _, _ -> acc
      }
    })
  use <- bool.guard(new_count > max, a)
  find_cuboids(a + 1, new_count)
}

fn shortest_path_is_integer(a, b_plus_c) {
  math.exact_square_root(a * a + b_plus_c * b_plus_c) |> result.is_ok
}
