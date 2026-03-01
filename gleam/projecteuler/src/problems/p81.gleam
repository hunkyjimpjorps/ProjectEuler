import aonyx/graph/dijkstra
import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import simplifile
import utilities/grid
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  let assert Ok(data) = simplifile.read("./data/81.txt")
  let node_dict = grid.to_node_dict(data, with: int.parse)

  grid.to_graph(node_dict, neighbors:, weighting:)
  |> dijkstra.find_path(#(0, 0), #(79, 79))
  |> option.unwrap([])
  |> list.filter_map(dict.get(node_dict, _))
  |> int.sum
}

fn neighbors(posn) {
  let #(r, c) = posn
  [#(r - 1, c), #(r, c - 1)]
}

fn weighting(_, v, _, _) {
  int.to_float(v)
}
