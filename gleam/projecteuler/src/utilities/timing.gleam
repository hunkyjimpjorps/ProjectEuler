import gleam/io
import gleam/string
import tempo/duration
import tempo/instant

pub fn run(f) {
  let before = instant.now()
  let result = f()
  let after = instant.now()

  let duration =
    instant.difference(before, after)
    |> duration.format()
  io.println("Answer: " <> string.inspect(result) <> " (" <> duration <> ")")
}

pub fn run_and_echo(f) {
  let before = instant.now()
  let result = f()
  let after = instant.now()

  let duration =
    instant.difference(before, after)
    |> duration.format()
  io.println("Answer: " <> string.inspect(result) <> " (" <> duration <> ")")
  result
}
