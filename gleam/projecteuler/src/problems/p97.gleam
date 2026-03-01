import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

const size = 10_000_000_000

fn solution() {
  { 28_433 * trimmed_pow(2, 7_830_457) + 1 } % size
}

pub fn trimmed_pow(x: Int, n: Int) -> Int {
  case n, n % 2 {
    0, _ -> 1
    n, 0 -> {
      let a = trimmed_pow(x, n / 2)
      { a * a } % size
    }
    n, _ -> { x * trimmed_pow(x, n - 1) } % size
  }
}
