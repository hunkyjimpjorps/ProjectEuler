import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

const denominator = 12_000

fn solution() {
  count_mediants(3, 2)
}

fn count_mediants(from, to) {
  let mediant = from + to
  case mediant > denominator {
    True -> 0
    False -> 1 + count_mediants(from, mediant) + count_mediants(mediant, to)
  }
}
