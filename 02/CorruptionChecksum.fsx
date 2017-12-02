let lines = System.IO.File.ReadLines("/Users/mariosangiorgio/Downloads/input")

let lineChecksum (line : string) : int =
  line
  |>