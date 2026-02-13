import gleam/int
import gleam/list
import utilities/timing

pub fn main() {
  timing.run(solution)
}

fn solution() {
  use a <- list.find_map(int.range(1, 500, [], list.prepend))
  use b <- list.find_map(int.range(a, 500, [], list.prepend))
  let c = 1000 - a - b
  case a * a + b * b == c * c {
    True -> Ok(a * b * c)
    False -> Error(Nil)
  }
}
