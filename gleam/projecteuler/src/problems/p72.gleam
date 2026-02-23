import gleam/dict
import problems/p69
import utilities/math
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

// This sequence is the Farey sequence, and the length of the Farey sequence of order n
// comes from the sum of totients Φ(n); |Fn| = Φ(n) + 1, minus two to omit 0/n and 1/1
// φ(1) = 1, so we can just omit that and the + 1 term from the sum

fn solution() {
  summatory_totient(1_000_000)
}

fn summatory_totient(n) {
  math.step_range(2, n, 1, dict.new(), fn(acc, n) { dict.insert(acc, n, n) })
  |> p69.compute_totients(2, n)
  |> dict.fold(0, fn(acc, _, v) { acc + v })
}
