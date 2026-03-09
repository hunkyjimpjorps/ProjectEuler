import gleam/int
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

const target = 2_000_000

const delta = 1000

fn solution() {
  let #(range, _) =
    math.step_to_find(1, 1, fn(i) {
      case rectangles_in_strip(i) >= target + delta {
        True -> Ok(i)
        False -> Error(Nil)
      }
    })
}

fn find_differences(width, acc) {
  todo
}

fn rectangles_in_strip(dimension: Int) -> Int {
  int.range(1, dimension + 1, 0, fn(acc, i) { acc + dimension - i + 1 })
}

fn rectangles(width: Int, height: Int) -> Int {
  rectangles_in_strip(width) * rectangles_in_strip(height)
}

fn within_range(n, n0, d) {
  n > n0 - d && n < n0 + d
}
