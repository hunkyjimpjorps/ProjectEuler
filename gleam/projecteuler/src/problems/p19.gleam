import gleam/list
import tempo/date
import tempo/period
import utilities/timing

pub fn main() -> Nil {
  timing.run(solution)
}

fn solution() {
  period.from_dates(
    start: date.literal("1901-01-01"),
    end: date.literal("2000-12-31"),
  )
  |> period.comprising_dates
  |> list.count(fn(date) {
    date.to_day_of_week(date) == date.Sun && date.get_day(date) == 1
  })
}
