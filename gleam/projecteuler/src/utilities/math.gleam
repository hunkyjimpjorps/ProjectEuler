import gleam/int
import gleam/order.{Eq, Gt, Lt}

pub fn pow(x: Int, n: Int) -> Int {
  case n {
    0 -> 1
    n if n % 2 == 0 -> {
      let a = pow(x, n / 2)
      a * a
    }
    n -> x * pow(x, n - 1)
  }
}

pub fn exact_square_root(radicand: Int) -> Result(Int, Nil) {
  do_exact_square_root(1, radicand, radicand)
}

fn do_exact_square_root(from: Int, to: Int, radicand: Int) -> Result(Int, Nil) {
  let guess = { from + to } / 2
  case int.compare(guess * guess, radicand) {
    Eq -> Ok(guess)
    _ if to - from == 1 -> Error(Nil)
    Gt -> do_exact_square_root(from, guess, radicand)
    Lt -> do_exact_square_root(guess, to, radicand)
  }
}

pub fn floor_square_root(radicand: Int) -> Int {
  do_floor_square_root(1, radicand, radicand)
}

fn do_floor_square_root(from: Int, to: Int, radicand: Int) -> Int {
  let guess = { from + to } / 2
  case int.compare(guess * guess, radicand) {
    Eq -> guess
    _ if to - from == 1 -> to
    Gt -> do_floor_square_root(from, guess, radicand)
    Lt -> do_floor_square_root(guess, to, radicand)
  }
}
