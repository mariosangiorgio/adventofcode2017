-module(spinlock).
-export([main/0, spinlock/5, item_after/2]).


spinlock(List, _Steps, _Current, ToInsert, Target) when  ToInsert > Target ->
  List;
spinlock(List, Steps, Current, ToInsert, Target) ->
  Destination = (Current + Steps) rem length(List) + 1,
  {Before, After} = lists:split(Destination, List),
  spinlock(Before ++ [ToInsert | After], Steps, Destination, ToInsert + 1, Target).

%% Note what happens when the item to we want is the last
item_after(ToFind, [H,I|_Tail]) when ToFind == H ->
  I;
item_after(ToFind, [H]) when ToFind == H ->
  head;
item_after(_ToFind, []) ->
  not_found;
item_after(ToFind, [_H|Tail]) ->
  item_after(ToFind, Tail).

main() ->
  Items = spinlock([0], 369, 0, 1, 2017),
  io:format("~w~n", [item_after(2017, Items)]).