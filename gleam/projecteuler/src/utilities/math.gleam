import gleam/float
import gleam/int
import gleam/order.{Eq, Gt, Lt}
import gleam/result

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

pub fn exact_nth_root(radicand: Int, power: Int) -> Result(Int, Nil) {
  do_exact_nth_root(1, radicand, radicand, power)
}

fn do_exact_nth_root(
  from: Int,
  to: Int,
  radicand: Int,
  power: Int,
) -> Result(Int, Nil) {
  let guess = { from + to } / 2
  case int.compare(pow(guess, power), radicand) {
    Eq -> Ok(guess)
    _ if to - from == 1 -> Error(Nil)
    Gt -> do_exact_nth_root(from, guess, radicand, power)
    Lt -> do_exact_nth_root(guess, to, radicand, power)
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

pub fn step_range(
  from current: Int,
  to stop: Int,
  by increment: Int,
  with acc: acc,
  run reducer: fn(acc, Int) -> acc,
) -> acc {
  case current > stop {
    True -> acc
    False -> {
      let acc = reducer(acc, current)
      let current = current + increment
      step_range(current, stop, increment, acc, reducer)
    }
  }
}

pub fn step_to_find(
  from current: Int,
  by increment: Int,
  run function: fn(Int) -> Result(a, b),
) -> #(Int, a) {
  case function(current) {
    Ok(success) -> #(current, success)
    Error(_) -> step_to_find(current + increment, increment, function)
  }
}

pub fn fold_while(
  from current: Int,
  to stop: Int,
  by increment: Int,
  starting acc: a,
  run function: fn(a, Int) -> Result(a, b),
) -> a {
  case current >= stop {
    True -> acc
    False ->
      case function(acc, current) {
        Ok(success) ->
          fold_while(current + increment, stop, increment, success, function)
        Error(_) -> acc
      }
  }
}

pub fn assert_int(n: String) -> Int {
  n |> int.parse() |> result.unwrap(0)
}

pub fn assert_float(n: String) -> Float {
  n |> float.parse() |> result.unwrap(0.0)
}
