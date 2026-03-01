import aonyx/graph
import aonyx/graph/edge
import aonyx/graph/node
import gleam/dict
import gleam/list
import gleam/string

pub fn to_node_dict(
  parse data: String,
  with parsing_function: fn(String) -> Result(a, b),
) -> dict.Dict(#(Int, Int), a) {
  use acc, row, r <- list.index_fold(string.split(data, "\n"), dict.new())
  use acc, col, c <- list.index_fold(string.split(row, ","), acc)
  let assert Ok(n) = parsing_function(col)
  dict.insert(acc, #(r, c), n)
}

pub fn to_graph(
  node_dict,
  neighbors neighbor_function,
  weighting weighting_function,
) {
  dict.fold(node_dict, graph.new(), fn(acc, k, _) {
    graph.insert_node(acc, node.new(k))
  })
  |> dict.fold(node_dict, _, fn(acc, k, v) {
    list.fold(neighbor_function(k), acc, fn(g, nk) {
      case dict.get(node_dict, nk) {
        Ok(nv) -> {
          edge.new(nk, k)
          |> edge.with_weight(weighting_function(k, v, nk, nv))
          |> graph.insert_edge(g, _)
        }
        Error(_) -> g
      }
    })
  })
}
