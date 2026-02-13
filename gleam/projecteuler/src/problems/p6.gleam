import utilities/timing

pub fn main() {
  timing.run(solution)
}

fn solution() {
  let n = 100
  let sum = n * { n + 1 } / 2
  let sum_of_squares = n * { n + 1 } * { 2 * n + 1 } / 6

  sum * sum - sum_of_squares
}
