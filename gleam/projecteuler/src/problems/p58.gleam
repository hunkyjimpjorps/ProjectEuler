import gleam/list
import gleam_community/maths
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> Int {
  find_ratio(3, 0, 1)
}

fn find_ratio(n: Int, prime_count: Int, total: Int) -> Int {
  let corners = [n * n - n + 1, n * n - 2 * n + 2, n * n - 3 * n + 3]
  let new_prime_count = prime_count + list.count(corners, maths.is_prime)
  let new_total = total + 4
  case new_prime_count * 10 / new_total < 1 {
    True -> n
    False -> find_ratio(n + 2, new_prime_count, new_total)
  }
}
