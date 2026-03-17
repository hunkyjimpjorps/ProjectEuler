import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

const denominator: Int = 12_000

fn solution() -> Int {
  count_mediants(3, 2)
}

fn count_mediants(from: Int, to: Int) -> Int {
  let mediant = from + to
  case mediant > denominator {
    True -> 0
    False -> 1 + count_mediants(from, mediant) + count_mediants(mediant, to)
  }
}
