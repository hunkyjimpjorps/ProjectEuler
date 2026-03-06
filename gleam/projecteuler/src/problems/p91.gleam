import gleam/int
import gleam/set
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

type XY {
  XY(x: Int, y: Int)
}

const range = 50

fn solution() {
  {
    let origin = XY(0, 0)
    use acc, px <- int.range(0, range + 1, set.new())
    use acc, py <- int.range(1, range + 1, acc)
    let p = XY(px, py)
    use acc, qx <- int.range(1, range + 1, acc)
    use acc, qy <- int.range(0, range + 1, acc)
    let q = XY(qx, qy)
    case right_triangle(origin, p, q) {
      True -> [p, q] |> set.from_list |> set.insert(acc, _)
      False -> acc
    }
  }
  |> set.size
}

fn right_triangle(a: XY, b: XY, c: XY) {
  let ab = dist_squared(a, b)
  let bc = dist_squared(b, c)
  let ac = dist_squared(a, c)

  b != c && { ab + bc == ac || ab + ac == bc || bc + ac == ab }
}

fn sq(n) {
  n * n
}

fn dist_squared(a: XY, b: XY) {
  sq(a.x - b.x) + sq(a.y - b.y)
}
