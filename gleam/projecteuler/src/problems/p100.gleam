import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  recurrence_relation(3, 1)
}

// since B/(B+R) * (B-1)/(B+R-1) = 1/2, B = R + (1 + √(8R^2 + 1))/2, 
// there needs to be some integer k such that k^2 = 8R^2 + 1 for B to be an integer,
// which is the Pell's equation with fundamental solution (3, 1)

fn recurrence_relation(root, red) {
  let blue = red + { 1 + root } / 2
  case blue + red > 1_000_000_000_000 {
    True -> blue
    False -> {
      let next_root = 3 * root + 8 * red
      let next_red = 3 * red + root
      recurrence_relation(next_root, next_red)
    }
  }
}
