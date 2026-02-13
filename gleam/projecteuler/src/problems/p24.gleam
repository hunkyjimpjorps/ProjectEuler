import gleam/int
import gleam/list
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  int.range(1, 10, [], list.prepend)
  |> list.reverse
  |> list.permutations()
  |> list.drop(999_999)
  |> list.first()
}
