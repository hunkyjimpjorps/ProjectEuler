import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  add_layer(1, 1)
}

fn add_layer(n, acc) {
  let upper_right = 4 * n * n + 4 * n + 1
  let lower_right = 4 * n * n - 2 * n + 1
  let lower_left = 4 * n * n + 1
  let upper_left = 4 * n * n + 2 * n + 1
  let acc = acc + upper_right + lower_right + lower_left + upper_left

  case n {
    500 -> acc
    _ -> add_layer(n + 1, acc)
  }
}
