import Html exposing (div, text)
import Array
import Set

input =
--  "0 2 7 0"
  "0 5 10 0 11 14 13 4 11 8 8 7 1 4 12 11"
  |> String.split " "
  |> List.map (String.toInt >> Result.withDefault 0)


findMax x (index, max, index_max) =
    if x > max
    then (index + 1, x, index)
    else (index + 1, max, index_max)

max list =
  let dropIndex (index, max, index_max) = (max, index_max)
  in
  List.foldl findMax (0,0,0) list
  |> dropIndex

increment index remaining array =
  if remaining == 0
  then array
  else
    let
      v = Array.get index array |> Maybe.withDefault 0
      next_index = (index+1) % (Array.length array)
    in
    array
    |> Array.set index (v+1)
    |> increment next_index (remaining - 1)


redistribute list =
  let (max_value, index_max) = max list
      array = Array.fromList list
  in
    array
    |> Array.set index_max 0
    |> increment ((index_max+1) % (Array.length array)) max_value
    |> Array.toList

iterate input iterations seen =
  let redistributed = redistribute input
  in
    if Set.member redistributed seen
    then iterations
    else iterate redistributed (iterations+1) (seen |> Set.insert redistributed)

main = div []
  [
  text <| toString <| input,
  text <| toString <| iterate input 1 <| Set.singleton input]