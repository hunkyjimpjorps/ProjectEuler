import gleam/int
import gleam/list
import gleam/set
import gleam_community/maths
import utilities/digits
import utilities/math.{pow}
import utilities/primes
import utilities/timing
import yog
import yog/model
import yog/properties/clique

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() -> Int {
  let primes = primes.up_to(10_000)

  let graph = yog.new(model.Undirected)

  {
    use acc, n <- list.fold(primes, graph)
    let acc = yog.add_node(acc, n, n)
    yog.all_nodes(acc)
    |> list.fold(acc, fn(g, m) {
      case forms_primes(n, m) {
        True -> yog.add_edge(g, n, m, 1)
        False -> g
      }
    })
  }
  |> clique.max_clique
  |> set.fold(0, int.add)
}

fn forms_primes(a: Int, b: Int) -> Bool {
  let sum1 = pow(10, digits.number_of_digits(b)) * a + b
  let sum2 = pow(10, digits.number_of_digits(a)) * b + a
  maths.is_prime(sum1) && maths.is_prime(sum2)
}
