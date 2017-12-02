let lines =
  System.IO.File.ReadLines("/Users/mariosangiorgio/Downloads/input")
  |> Seq.toList // Need to iterate twice, one for part

let parse (line : string) : int list =
  line.Trim().Split('\t')
  |> Seq.map int
  |> Seq.toList

let lineChecksum (line : string) : int =
  let values = parse line
  (values |> Seq.max) - (values |> Seq.min)

// Part 1
lines
|> Seq.map lineChecksum
|> Seq.sum

let evenlyDivisible (line : string) : int =
  let rec findEvenlyDivisible values =
    match values with
    | candidate :: others ->
      others
      |> Seq.tryPick (fun other ->
        if other % candidate = 0
        then Some(other / candidate)
        else if candidate % other = 0
        then Some(candidate / other)
        else None
        )
      |> (function
          | Some(v) -> v
          | None -> findEvenlyDivisible(others))
    | [] -> failwith "There should have been a pair!"

  parse line
  |> findEvenlyDivisible

// Part 2
lines
|> Seq.map evenlyDivisible
|> Seq.sum