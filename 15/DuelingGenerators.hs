next :: Integer -> Integer -> Integer
next factor previous = mod (factor * previous) 2147483647

next1 :: Integer -> Integer
next1 = next 16807
next2 :: Integer -> Integer
next2 = next 48271

numbers1 :: [Integer]
numbers1 = (next1 722) : map next1 numbers1
numbers2 :: [Integer]
numbers2 = (next2 354) : map next2 numbers2

matchingLowerBits :: Integer -> Integer -> Bool
matchingLowerBits a b =
    let x = 65536
    in (mod a x) == (mod b x)

multiples :: Integer -> [Integer] -> [Integer]
multiples n a =
  let f x = (mod x n) == 0
  in filter f a

main =
    let
        part1 =  length . (filter id) . (take 40000000) $ (zipWith matchingLowerBits numbers1 numbers2)
        part2 =  length . (filter id) . (take 5000000) $
                  (zipWith matchingLowerBits (multiples 4 numbers1) (multiples 8 numbers2))
    in
      do
      print part1
      print part2