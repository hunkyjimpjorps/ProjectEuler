import gleam/list
import gleam_community/maths
import utilities/timing

pub fn main() {
  timing.run(solution)
}

fn solution() {
  find_goal(1, 2)
}

fn find_goal(number n, index k) {
  echo n
  case list.length(maths.divisors(n)) > 500 {
    True -> n
    False -> find_goal(n + k, k + 1)
  }
}
