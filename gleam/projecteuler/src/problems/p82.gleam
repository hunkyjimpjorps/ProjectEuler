import aonyx/graph
import aonyx/graph/dijkstra
import aonyx/graph/node
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

  let graph =
    grid.to_graph(node_dict, neighbors:, weighting:)
    |> graph.insert_node(
      node.new(#(-1, -1)) |> node.with_outgoing(all_in_column(0)),
    )
    |> graph.insert_node(
      node.new(#(99, 99)) |> node.with_incoming(all_in_column(79)),
    )

  dijkstra.find_path(graph, #(-1, -1), #(99, 99))
  |> option.unwrap([])
  |> list.filter_map(dict.get(node_dict, _))
  |> int.sum
}

fn neighbors(posn) {
  let #(r, c) = posn
  [#(r + 1, c), #(r - 1, c), #(r, c - 1)]
}

fn weighting(_, v, _, _) {
  int.to_float(v)
}

fn all_in_column(c) {
  int.range(0, 80, [], fn(acc, n) { [#(n, c), ..acc] })
}
