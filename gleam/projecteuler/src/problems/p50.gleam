import gleam/dict
import gleam/int
import gleam/order
import gleam/set
import utilities/primes
import utilities/timing

const limit = 1_000_000

pub fn main() {
  timing.run(solution)
}

fn solution() {
  let all_primes = primes.up_to(limit)
  let all_primes_set = all_primes |> set.from_list

  all_running_sums(all_primes, all_primes_set, dict.new())
  |> dict.fold(#(0, 0), fn(acc, k, v) {
    let #(k_max, v_max) = acc
    case int.compare(v, v_max) {
      order.Eq -> #(int.max(k, k_max), v_max)
      order.Gt -> #(k, v)
      order.Lt -> acc
    }
  })
}

fn running_sum(xs, keep) {
  do_running_sum(xs, 0, [], 1, keep)
}

fn do_running_sum(xs, sum, acc, i, keep) {
  case xs {
    [] -> acc
    _ if sum > limit -> acc
    [h, ..t] -> {
      let next_sum = sum + h
      let next_acc = case set.contains(keep, next_sum) {
        True -> [#(sum + h, i), ..acc]
        False -> acc
      }
      do_running_sum(t, sum + h, next_acc, i + 1, keep)
    }
  }
}

fn all_running_sums(primes, keep, acc) {
  case primes {
    [] -> acc
    [_, ..t] -> {
      let this_rep = running_sum(primes, keep) |> dict.from_list
      let new_acc = dict.combine(acc, this_rep, int.max)
      all_running_sums(t, keep, new_acc)
    }
  }
}
