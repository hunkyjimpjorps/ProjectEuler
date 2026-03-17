import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> Int {
  find_multiples(1, 0)
}

fn find_multiples(n: Int, sum: Int) -> Int {
  case n < 1000 {
    True if n % 3 == 0 || n % 5 == 0 -> find_multiples(n + 1, sum + n)
    True -> find_multiples(n + 1, sum)
    False -> sum
  }
}
