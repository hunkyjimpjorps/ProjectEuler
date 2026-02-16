import gleam/int
import gleam/set
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  {
    use acc, a <- int.range(2, 101, set.new())
    use acc, b <- int.range(2, 101, acc)
    set.insert(acc, math.pow(a, b))
  }
  |> set.size
}
