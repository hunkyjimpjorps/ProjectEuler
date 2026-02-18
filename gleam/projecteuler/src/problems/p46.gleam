import gleam/int
import gleam/list
import gleam/yielder
import gleam_community/maths
import utilities/math
import utilities/timing

pub fn main() {
  timing.run(solution)
}

fn solution() {
  yielder.iterate(33, int.add(_, 2))
  |> yielder.find(fn(n) { !maths.is_prime(n) && !meets_conjecture(n) })
}

fn meets_conjecture(n) {
  let s_max = math.floor_square_root(n / 2) + 1
  int.range(1, s_max, [], fn(acc, s) { [s * s, ..acc] })
  |> list.any(fn(s) { maths.is_prime(n - 2 * s) })
}
