import gleam/int
import gleam_community/maths
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> Int {
  int.range(2, 21, 1, maths.lcm)
}
