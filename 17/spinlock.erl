-module(spinlock).
-export([main/0]).


spinlock(List, _Steps, _Current, ToInsert, Target) when  ToInsert > Target ->
  List;
spinlock(List, Steps, Current, ToInsert, Target) ->
  Destination = (Current + Steps) rem length(List) + 1,
  {Before, After} = lists:split(Destination, List),
  spinlock(Before ++ [ToInsert | After], Steps, Destination, ToInsert + 1, Target).

after_zero(_Count, ValueAfterZero, _Steps, _Current, ToInsert, Target) when  ToInsert > Target ->
  ValueAfterZero;
after_zero(Count, ValueAfterZero, Steps, Current, ToInsert, Target) ->
  Destination = (Current + Steps) rem Count + 1,
  NewValueAfterZero =
    if
      Destination == 1 ->
        ToInsert;
      true ->
        ValueAfterZero
    end,
  after_zero(Count + 1, NewValueAfterZero, Steps, Destination, ToInsert + 1, Target).

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
  io:format("~w~n", [item_after(2017, Items)]),
  io:format("~w~n", [after_zero(1, none, 369, 0, 1, 50000000)]).