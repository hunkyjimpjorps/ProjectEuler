import gleam/list
import gleam_community/maths
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> Int {
  find_goal(1, 2)
}

fn find_goal(number n: Int, index k: Int) -> Int {
  case list.length(maths.divisors(n)) > 500 {
    True -> n
    False -> find_goal(n + k, k + 1)
  }
}
