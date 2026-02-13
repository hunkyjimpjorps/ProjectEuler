import utilities/timing

pub fn main() {
  timing.run(solution)
}

fn solution() {
  add_even_terms(1, 1, 0)
}

fn add_even_terms(a: Int, b: Int, sum: Int) -> Int {
  case a + b {
    _ if b > 4_000_000 -> sum
    c if c % 2 == 0 -> add_even_terms(b, c, sum + c)
    c -> add_even_terms(b, c, sum)
  }
}
