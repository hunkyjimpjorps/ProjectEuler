import gleam/bool
import gleam/int
import gleam/list
import gleam/string
import simplifile
import utilities/timing

pub fn main() {
  timing.run(solution)
}

type XY {
  XY(x: Int, y: Int)
}

type Line {
  Line(from: XY, to: XY)
}

type Triangle {
  Triangle(a: XY, b: XY, c: XY)
}

const origin_ray = Line(XY(0, 0), XY(1001, 0))

fn solution() {
  let assert Ok(data) = simplifile.read("./data/102.txt")

  list.map(string.split(data, "\n"), parse_triangle)
  |> list.count(origin_inside_triangle)
}

fn parse_triangle(line: String) {
  let assert [ax, ay, bx, by, cx, cy] =
    line |> string.split(",") |> list.filter_map(int.parse)

  Triangle(XY(ax, ay), XY(bx, by), XY(cx, cy))
}

fn origin_inside_triangle(triangle: Triangle) {
  let sides = [
    Line(triangle.a, triangle.b),
    Line(triangle.b, triangle.c),
    Line(triangle.c, triangle.a),
  ]
  list.count(sides, fn(s) { intersects(s, origin_ray) }) == 1
}

fn intersects(line1: Line, line2: Line) {
  let #(Line(a, b), Line(c, d)) = #(line1, line2)
  bool.exclusive_or(counterclockwise(a, c, d), counterclockwise(b, c, d))
  && bool.exclusive_or(counterclockwise(a, b, c), counterclockwise(a, b, d))
}

fn counterclockwise(a: XY, b: XY, c: XY) {
  { c.y - a.y } * { b.x - a.x } > { b.y - a.y } * { c.x - a.x }
}
