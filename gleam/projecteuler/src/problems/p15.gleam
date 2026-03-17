import gleam_community/maths
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> Result(Int, Nil) {
  maths.combination(40, 20)
}
