import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

const limit = 1_000_000_000

fn solution() {
  // Slow brute-force solution that the sequence generator is based on
  // use acc, a <- math.step_range(5, 1_000_000_000 / 3, 1, 0)
  // case math.exact_square_root(4 * a * a - math.pow(a - 1, 2)) {
  //   Ok(..) -> acc + 3 * a - 1
  //   Error(..) ->
  //     case math.exact_square_root(4 * a * a - math.pow(a + 1, 2)) {
  //       Ok(..) -> acc + 3 * a + 1
  //       Error(..) -> acc
  //     }
  // }

  next_pair(#(722, 50), #(196, 16), 16 + 50 + 196 + 722)
}

fn next_pair(shorters, longers, acc) {
  let #(s1, s0) = shorters
  let #(l1, l0) = longers
  let s2 = 14 * s1 - s0 + 24
  let l2 = 14 * l1 - l0 - 24
  case s2 > limit || l2 > limit {
    True -> acc
    False -> next_pair(#(s2, s1), #(l2, l1), acc + s2 + l2)
  }
}
