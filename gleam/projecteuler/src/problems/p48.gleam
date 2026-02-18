import gleam/int
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  int.range(1, 1001, 0, fn(acc, n) { { acc + math.pow(n, n) } % 10_000_000_000 })
}
