import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  try_next_triangular(286)
}

fn try_next_triangular(n) {
  let t_n = triangular(n)

  case is_pentagonal(t_n) && is_hexagonal(t_n) {
    True -> t_n
    False -> try_next_triangular(n + 1)
  }
}

fn triangular(n) {
  n * { n + 1 } / 2
}

fn is_pentagonal(t: Int) -> Bool {
  case math.square_root(24 * t + 1) {
    Ok(s) -> { 1 + s } % 6 == 0
    Error(_) -> False
  }
}

fn is_hexagonal(t: Int) -> Bool {
  case math.square_root(8 * t + 1) {
    Ok(s) -> { 1 + s } % 4 == 0
    Error(_) -> False
  }
}
