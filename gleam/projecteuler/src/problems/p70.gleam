import gleam/int
import gleam/list
import gleam/yielder
import gleam_community/maths
import utilities/digits
import utilities/primes
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  let assert Ok(prime_pairs) =
    primes.up_to(5_000)
    |> list.drop_while(fn(n) { n < 1000 })
    |> maths.list_combination(2)

  yielder.fold(prime_pairs, #(1, 10_000_000.0), fn(acc, xs) {
    let assert [p, q] = xs
    let k = p * q
    let totient = { p - 1 } * { q - 1 }
    case k < 10_000_000 && digits.are_permutations(k, totient) {
      False -> acc
      True -> {
        let div = int.to_float(k) /. int.to_float(totient)
        case div <. acc.1 {
          False -> acc
          True -> #(k, div)
        }
      }
    }
  })
}
