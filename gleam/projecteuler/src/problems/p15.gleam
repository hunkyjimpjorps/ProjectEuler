import gleam_community/maths
import utilities/timing

pub fn main() {
  timing.run(solution)
}

fn solution() {
  maths.combination(40, 20)
}
