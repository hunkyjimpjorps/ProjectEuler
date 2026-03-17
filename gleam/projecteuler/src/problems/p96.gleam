import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/regexp
import gleam/result
import gleam/set.{type Set}
import gleam/string
import simplifile
import utilities/timing

pub type Cell {
  Cell(row: Int, column: Int)
}

pub type Sudoku {
  Sudoku(puzzle: Dict(Cell, Value), open_cells: List(Cell))
}

pub type Value {
  Fixed(Int)
  Open(Set(Int))
}

fn in_row(sudoku: Sudoku, row: Int) -> List(#(Cell, Value)) {
  use acc, col <- int.range(9, 0, [])
  let assert Ok(set) = dict.get(sudoku.puzzle, Cell(row, col))
  [#(Cell(row, col), set), ..acc]
}

fn in_col(sudoku: Sudoku, col: Int) -> List(#(Cell, Value)) {
  use acc, row <- int.range(9, 0, [])
  let assert Ok(set) = dict.get(sudoku.puzzle, Cell(row, col))
  [#(Cell(row, col), set), ..acc]
}

fn in_block(sudoku: Sudoku, row: Int, col: Int) -> List(#(Cell, Value)) {
  let max_row = end_of_block(row)
  let max_col = end_of_block(col)

  use acc, row <- int.range(max_row, max_row - 3, [])
  use acc, col <- int.range(max_col, max_col - 3, acc)
  let assert Ok(set) = dict.get(sudoku.puzzle, Cell(row, col))
  [#(Cell(row, col), set), ..acc]
}

fn end_of_block(coordinate: Int) -> Int {
  case coordinate {
    1 | 2 | 3 -> 3
    4 | 5 | 6 -> 6
    7 | 8 | 9 -> 9
    _ -> panic
  }
}

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> Int {
  let assert Ok(input) = simplifile.read("./data/96.txt")

  let assert Ok(grids) =
    regexp.from_string("Grid ..\n")
    |> result.map(regexp.split(_, input))
    |> result.replace_error(Nil)
    |> result.try(list.rest)

  list.filter_map(grids, fn(str) {
    str
    |> parse_grid
    |> find_open_cells
    |> solution_loop
    |> result.try(make_solution_key)
  })
  |> int.sum
}

fn parse_grid(input: String) -> Sudoku {
  let puzzle = {
    use acc, row, r <- list.index_fold(
      input |> string.trim |> string.split("\n"),
      dict.new(),
    )
    use acc, col, c <- list.index_fold(string.to_graphemes(row), acc)
    let assert Ok(n) = int.parse(col)
    let value = case n {
      0 -> Open(set.from_list([1, 2, 3, 4, 5, 6, 7, 8, 9]))
      _ -> Fixed(n)
    }
    dict.insert(acc, Cell(r + 1, c + 1), value)
  }

  Sudoku(puzzle:, open_cells: [])
}

fn solution_loop(sudoku: Sudoku) -> Result(Sudoku, Nil) {
  case list.is_empty(sudoku.open_cells) {
    True -> Ok(sudoku)
    False -> {
      let updated_sudoku = fix_singletons(sudoku)
      case updated_sudoku {
        Error(Nil) -> Error(Nil)
        Ok(Sudoku(p, _)) if p == sudoku.puzzle -> make_guess(sudoku)
        Ok(s) -> s |> find_open_cells |> solution_loop
      }
    }
  }
}

fn find_open_cells(sudoku: Sudoku) -> Sudoku {
  sudoku.puzzle
  |> dict.filter(fn(_, v) {
    case v {
      Open(..) -> True
      _ -> False
    }
  })
  |> dict.keys
  |> Sudoku(sudoku.puzzle, open_cells: _)
}

fn fix_singletons(sudoku: Sudoku) -> Result(Sudoku, Nil) {
  case sudoku.open_cells {
    [] -> Ok(sudoku)
    [next, ..rest] -> {
      let assert Ok(Open(candidates)) = dict.get(sudoku.puzzle, next)
      let in_same_row = in_row(sudoku, next.row)
      let in_same_col = in_col(sudoku, next.column)
      let in_same_block = in_block(sudoku, next.row, next.column)

      let new_candidates =
        list.flatten([in_same_row, in_same_col, in_same_block])
        |> list.fold(set.new(), fn(acc, tup) {
          case tup {
            #(_, Fixed(n)) -> set.insert(acc, n)
            _ -> acc
          }
        })
        |> set.difference(candidates, _)

      case set.is_empty(new_candidates) {
        True -> Error(Nil)
        False -> {
          case set.to_list(new_candidates) {
            [n] -> dict.insert(sudoku.puzzle, next, Fixed(n))
            _ -> dict.insert(sudoku.puzzle, next, Open(new_candidates))
          }
          |> Sudoku(rest)
          |> fix_singletons
        }
      }
    }
  }
}

fn make_guess(sudoku: Sudoku) -> Result(Sudoku, Nil) {
  let assert Ok(cell) =
    list.max(sudoku.open_cells, fn(c1, c2) {
      let assert Ok(Open(set1)) = dict.get(sudoku.puzzle, c1)
      let assert Ok(Open(set2)) = dict.get(sudoku.puzzle, c2)
      int.compare(set.size(set2), set.size(set1))
    })
  let assert Ok(Open(candidates)) = cell |> dict.get(sudoku.puzzle, _)

  list.find_map(set.to_list(candidates), fn(c) {
    sudoku.puzzle
    |> dict.insert(cell, Fixed(c))
    |> Sudoku(open_cells: [])
    |> find_open_cells
    |> solution_loop
  })
}

fn make_solution_key(sudoku: Sudoku) -> Result(Int, a) {
  let assert [Fixed(a), Fixed(b), Fixed(c)] =
    [Cell(1, 1), Cell(1, 2), Cell(1, 3)]
    |> list.filter_map(dict.get(sudoku.puzzle, _))

  Ok(100 * a + 10 * b + c)
}

pub fn print_puzzle(sudoku: Sudoku) -> Nil {
  sudoku.puzzle
  |> dict.to_list
  |> list.sort(fn(tup1, tup2) {
    let assert [#(c1, _), #(c2, _)] = [tup1, tup2]
    order.break_tie(
      int.compare(c1.row, c2.row),
      int.compare(c1.column, c2.column),
    )
  })
  |> list.map(fn(tup) {
    case tup.1 {
      Open(..) -> "x"
      Fixed(n) -> int.to_string(n)
    }
  })
  |> list.sized_chunk(9)
  |> list.map(string.concat)
  |> list.each(io.println)
}
