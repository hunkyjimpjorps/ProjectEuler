import gleam/dict
import gleam/list
import gleam/string
import simplifile
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  let assert Ok(raw_grid) = simplifile.read("./data/81.txt")

  parse_input(raw_grid)
}

fn parse_input(str) {
  {
    use row, r <- list.index_map(string.split(str, "\n"))
    use col, c <- list.index_map(string.split(row, ","))
    #(#(r, c), )
  }
}
