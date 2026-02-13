import gleam/int
import gleam_community/maths
import utilities/timing

pub fn main() {
  timing.run(solution)
}

fn solution() {
  int.range(2, 21, 1, maths.lcm)
}
