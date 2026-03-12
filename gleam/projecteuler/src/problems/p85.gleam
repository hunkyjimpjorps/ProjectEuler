import gleam/int.{absolute_value as abs}
import gleam/list
import gleam/result
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

const target = 2_000_000

const delta = 1000

fn solution() {
  let #(range, _) =
    math.step_to_find(1, 1, fn(i) {
      case rectangles_in_strip(i) >= target + delta {
        True -> Ok(i)
        False -> Error(Nil)
      }
    })

  use acc, width <- math.fold_while(from: 1, to: range, by: 1, starting: [])
  let diffs = {
    use acc, height <- math.fold_while(from: 1, to: range, by: 1, starting: acc)
    let rects = rectangles(width, height)
    case rects <= target + delta {
      True -> Ok([#(abs(target - rects), width * height), ..acc])
      False -> Error(Nil)
    }
  }
  case diffs {
    [] -> Error(Nil)
    xs ->
      xs
      |> list.max(fn(t1, t2) { int.compare(t2.0, t1.0) })
      |> result.map(list.wrap)
  }
}

fn rectangles_in_strip(dimension: Int) -> Int {
  int.range(1, dimension + 1, 0, fn(acc, i) { acc + dimension - i + 1 })
}

fn rectangles(width: Int, height: Int) -> Int {
  rectangles_in_strip(width) * rectangles_in_strip(height)
}