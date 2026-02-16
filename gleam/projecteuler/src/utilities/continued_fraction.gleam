import gleam/bool
import gleam/float
import gleam/int
import gleam/list
import gleam/set.{type Set}

pub fn find(n: Int) -> List(Int) {
  let assert Ok(root) = int.square_root(n)
  let a0 = float.truncate(root)
  do_expansion(n, a0, a0, 0, 1, [a0], set.new())
}

fn do_expansion(
  s: Int,
  a0: Int,
  a: Int,
  m: Int,
  d: Int,
  acc: List(Int),
  seen: Set(#(Int, Int, Int)),
) -> List(Int) {
  let m_next = d * a - m
  let d_next = { s - m_next * m_next } / d
  let a_next = { a0 + m_next } / d_next

  use <- bool.guard(
    set.contains(seen, #(m_next, d_next, a_next)),
    list.reverse(acc),
  )
  let acc = [a_next, ..acc]
  let seen = set.insert(seen, #(m_next, d_next, a_next))
  do_expansion(s, a0, a_next, m_next, d_next, acc, seen)
}

pub fn to_rational(terms: List(Int)) -> #(Int, Int) {
  let assert [first, ..rest] = list.reverse(terms)
  do_rational(rest, #(first, 1))
}

fn do_rational(terms: List(Int), frac: #(Int, Int)) -> #(Int, Int) {
  let #(num, den) = frac
  case terms {
    [] -> frac
    [a, ..rest] -> {
      do_rational(rest, #(a * num + den, num))
    }
  }
}
