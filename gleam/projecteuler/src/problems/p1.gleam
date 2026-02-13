import utilities/timing

pub fn main() {
  timing.run(solution)
}

fn solution() {
  find_multiples(1, 0)
}

fn find_multiples(n, sum) {
  case n < 1000 {
    True if n % 3 == 0 || n % 5 == 0 -> find_multiples(n + 1, sum + n)
    True -> find_multiples(n + 1, sum)
    False -> sum
  }
}
