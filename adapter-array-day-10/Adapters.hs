import Data.List

inputDemo1 :: [Int]
inputDemo1 = [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]

inputDemo2 :: [Int]
inputDemo2 = [28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3]

input :: [Int]
input = [73, 114, 100, 122, 10, 141, 89, 70, 134, 2, 116, 30, 123, 81, 104, 42, 142, 26, 15, 92, 56, 60, 3, 151, 11, 129, 167, 76, 18, 78, 32, 110, 8, 119, 164, 143, 87, 4, 9, 107, 130, 19, 52, 84, 55, 69, 71, 83, 165, 72, 156, 41, 40, 1, 61, 158, 27, 31, 155, 25, 93, 166, 59, 108, 98, 149, 124, 65, 77, 88, 46, 14, 64, 39, 140, 95, 113, 54, 66, 137, 101, 22, 82, 21, 131, 109, 45, 150, 94, 36, 20, 33, 49, 146, 157, 99, 7, 53, 161, 115, 127, 152, 128]

calcAdapterDiff xs =
  let charger = 3 + maximum xs
      sortedJolts = sort (charger:xs)
      diffs = zipWith (-) sortedJolts (0:sortedJolts)
      diffCounts = map length . group $ sort diffs
  in case diffCounts of
    [_]               -> 0
    [ones, threes]    -> ones * threes
    [ones, _, threes] -> ones * threes

countChains adapters = roll sortedChain
  where
    sortedChain = (0, 0):(0, 0):(0, 1):(map (\x -> (x, 0)) $ sort $ (3 + maximum adapters):adapters)
    roll :: [(Int, Int)] -> Int
    roll (a:b:c:d:chain)
      | null chain = waysToGetToD
      | otherwise  = roll (b:c:(fst d, waysToGetToD):chain)
      where
        waysToGetToD = sum $ map snd $ filter (\x -> (fst d - fst x) <= 3) [a, b, c]

main = do
  let [d1, d2, ans] = map (\i -> (calcAdapterDiff i, countChains i)) [inputDemo1, inputDemo2, input]
  putStrLn $ "             (adapter diffs, combinations)"
  putStrLn $ "             -----------------------------"
  putStrLn $ "Demo input 1 |" ++ (show $ d1)
  putStrLn $ "Demo input 2 |" ++ (show $ d2)
  putStrLn $ "Input        |" ++ (show $ ans)
