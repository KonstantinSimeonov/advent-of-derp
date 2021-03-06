{-# LANGUAGE OverloadedStrings #-}

import qualified Data.Text as T
import Data.Array.IArray
import qualified Data.Set as S
import Data.Maybe

--input = "nop +0\nacc +1\njmp +4\nacc +3\njmp -3\nacc -99\nacc +1\njmp -4\nacc +6"

input = "acc +50\nacc -11\nnop +378\nacc +15\njmp +508\nacc -3\njmp +1\njmp +135\njmp +1\nacc -6\nacc +14\nacc +32\njmp +315\nacc -16\njmp +249\njmp +283\nacc -14\nacc +5\nacc +29\njmp +366\nacc +22\njmp +77\nacc +19\njmp +496\nacc -2\nacc -16\nnop +284\nnop +36\njmp +178\njmp +281\nacc +32\nacc +45\nacc +16\njmp +403\nnop +86\nnop +32\nacc +10\njmp +47\nacc -13\nacc +35\njmp +270\njmp +1\nacc +34\nacc -3\nnop +116\njmp +552\nacc +27\nnop +113\njmp +495\nacc -18\nacc +47\nacc +19\njmp +180\nacc -8\nacc -1\nacc -14\nacc +17\njmp +431\nacc +49\nacc +22\nacc +39\nacc +28\njmp +74\njmp -10\nacc -5\nacc +35\njmp +251\nacc +31\nacc -11\njmp -49\nacc -12\nacc +49\njmp +36\nacc -19\nacc -9\nacc +11\nacc -1\njmp +419\njmp +307\nacc +36\njmp +563\nacc +32\nacc +1\njmp +270\nacc +17\njmp +464\njmp +133\nacc +29\nacc +31\njmp +394\nacc -2\njmp +94\nacc +44\nacc +28\nacc +32\njmp +543\nacc +18\njmp +325\nacc +16\nacc +42\njmp +315\nacc -6\njmp +371\nacc +41\nacc +29\njmp +44\nacc -19\njmp +393\nacc +4\njmp +81\nacc +25\njmp +108\nacc -18\njmp +1\njmp +1\nacc +34\njmp +124\nacc +25\nacc +45\njmp -46\nacc -11\nacc +43\nacc +50\njmp +6\nacc +3\nacc -6\nacc +38\nacc +9\njmp +402\nacc +26\nnop +97\nacc +26\njmp +115\nacc -1\nacc +2\njmp +7\nacc +38\nnop +5\njmp -75\nacc +41\nnop +470\njmp +15\nacc -15\nacc +19\nacc +22\njmp +240\nacc +14\nacc +26\njmp +71\nacc +38\nacc +25\njmp +349\nacc +25\nacc +31\nacc +41\njmp +419\njmp -69\nacc +50\nnop +218\njmp -106\nnop +225\njmp +307\nacc +33\nacc -4\nacc +36\njmp -57\nacc +14\nacc +0\nacc -2\njmp +184\nacc +47\nnop +161\nacc -4\njmp -149\njmp +103\nacc +39\nacc +25\nacc +8\nacc +2\njmp +364\nacc +48\njmp +241\nnop +432\nacc +9\njmp +304\nacc +20\njmp +223\nacc +12\nacc +21\njmp +121\nacc +12\nacc +47\nacc +50\nacc +8\njmp +283\njmp +1\njmp +81\nacc +22\nacc -6\njmp +1\nacc -9\njmp +340\nacc -9\nacc +5\nacc +11\njmp +204\nacc -13\nacc +12\njmp +322\nacc +38\nacc +50\nnop +211\njmp +91\nacc +31\nacc +34\njmp -95\nacc +12\nacc +13\njmp -172\nnop +419\njmp +1\nnop -191\nacc +48\njmp +157\nacc +22\nacc +27\njmp +61\nacc +23\nnop +181\njmp -121\nnop +367\njmp -168\njmp +1\nnop -218\njmp -142\njmp +295\njmp +112\nacc +9\nacc -12\njmp +114\nacc +50\njmp -28\nacc +18\nnop -223\nacc +37\nacc -14\njmp +169\nacc +0\nacc +42\njmp +115\nacc +2\nacc +31\njmp -189\nacc +7\nacc +45\nacc -2\nacc +34\njmp -121\nacc -13\nacc +4\nnop -94\nacc +34\njmp +123\nacc -11\nacc -13\njmp -29\nacc -11\nnop -169\nacc -11\nnop +369\njmp +189\nacc -4\njmp +20\nnop +19\nacc -13\nnop +368\njmp -79\nacc -19\nacc +23\nacc -7\nacc -11\njmp +36\nacc -18\nacc +31\nnop +349\nacc +11\njmp -106\nacc +43\njmp +185\nacc +20\nnop +297\njmp +138\nacc +8\nacc +26\nacc -2\njmp -18\nnop -276\njmp +44\njmp +1\nacc +39\njmp +314\nacc +0\njmp -194\nacc +32\nacc +17\nacc +43\njmp -298\nacc +28\nacc -10\njmp -103\nacc -17\nacc +3\njmp +25\nacc +35\nacc +7\nacc -2\njmp -39\nacc +19\nacc +19\nacc -8\njmp -282\njmp -275\nacc -7\njmp +196\nacc +14\nacc +5\njmp +6\nacc -7\njmp +29\nnop +275\nacc -12\njmp +165\nacc +21\nacc +4\njmp +95\nacc +15\njmp -283\njmp +199\nacc -9\nacc +0\njmp -220\nacc +28\nacc +1\njmp -313\nacc +13\nacc -5\nacc +38\njmp +62\nacc +43\njmp -159\nacc -14\nacc +44\njmp -314\nacc +3\nacc +34\njmp +47\njmp -171\nacc +27\nacc +11\nacc +16\njmp +16\nacc +27\nacc +40\njmp +66\nacc +30\nacc -15\njmp +177\nacc +36\nacc +41\njmp -189\nacc -19\njmp +106\nnop +271\nnop -176\nacc +13\njmp +40\nnop +33\njmp -324\nacc +18\njmp -76\nacc +38\nacc +39\nacc +34\njmp +231\njmp -131\nacc +46\nacc +38\nacc -3\njmp -161\nacc +31\nacc +10\njmp +158\nacc -18\nacc +46\njmp -291\njmp +48\nacc +18\nacc +36\nacc +16\njmp -77\nacc +9\njmp -289\nacc +38\njmp -388\nnop +137\nacc +42\nacc +17\nnop -37\njmp -145\njmp -336\nacc +46\nacc -18\nacc -13\nacc +21\njmp -97\nacc +49\nnop -189\nacc +21\njmp -186\nacc +25\nacc +37\njmp +193\njmp +1\nacc -14\nacc +4\njmp +87\nacc +3\nnop -95\njmp -243\nacc +30\nacc +35\njmp -128\njmp +1\nnop +55\nacc +48\njmp +129\njmp +1\nacc +37\njmp -326\nacc -2\nacc -13\nacc +37\njmp -72\nacc +23\njmp +130\nacc +18\nacc +0\nacc +36\njmp -345\nacc +0\nacc +23\nacc +10\njmp +1\njmp -112\nnop -430\nacc +8\nacc +42\njmp +1\njmp +180\nnop -16\nacc +22\njmp +1\nacc +2\njmp +43\nacc +29\nacc +23\nacc -2\njmp -364\nacc +14\njmp -250\nacc -11\nnop -359\njmp +132\njmp -24\nnop +90\nacc +32\njmp -461\njmp -311\nacc +11\nacc +21\njmp -320\njmp -194\njmp -165\nacc +43\nacc +5\nacc +12\njmp -419\njmp -467\nacc +47\nacc +35\njmp +133\nacc +10\nnop -394\nacc +35\nnop -109\njmp -298\nacc -10\nnop -451\njmp -445\njmp +57\nacc +31\nnop -1\njmp -59\nacc +19\nacc +7\njmp -5\nacc +31\nacc +0\nacc +29\nacc -8\njmp -118\njmp -119\nacc +35\njmp -339\nacc +14\nnop +28\nacc +0\nacc +25\njmp -265\nacc -9\nacc +29\njmp -365\nnop +19\nacc +31\nacc +16\njmp -116\njmp -442\nacc +24\nacc -3\njmp -505\nacc -5\njmp -485\nacc -12\nacc +15\njmp +1\njmp -16\nacc +23\nnop -135\njmp +26\nacc -16\njmp -374\njmp -171\njmp -518\nacc +23\nacc +23\njmp -282\nnop -78\nnop -230\njmp -285\nacc +39\nacc +31\njmp -219\nacc -18\njmp +1\nacc +43\njmp -175\nacc +46\nnop -391\njmp -305\nacc -11\nacc +41\nacc +33\nacc -9\njmp +70\nnop -8\nacc -3\nacc -16\nacc +8\njmp -139\nnop -237\nacc +1\nnop -405\nacc +16\njmp +14\nacc +0\nacc +35\nacc +26\nacc +43\njmp +71\nnop -187\nnop -188\njmp -7\nacc +34\nacc +11\nnop -35\njmp -104\njmp -37\njmp +1\nacc +37\nacc +1\nnop -78\njmp +19\nacc +35\nacc +35\nacc -3\nacc +0\njmp -377\nacc +49\njmp -519\nacc -18\nacc -5\nacc -15\nnop -76\njmp -530\nacc +7\nacc +0\njmp -19\nacc +15\nacc +37\njmp -79\njmp -339\nnop -398\nacc -16\njmp +20\nacc -15\nacc -5\nacc +20\nacc -12\njmp -21\nacc +39\nacc +32\nacc +34\njmp -330\nacc +48\nacc +2\nacc -8\nacc -15\njmp -231\nacc +35\nacc -16\nacc +26\nnop -547\njmp -548\nacc +6\nacc +20\nacc +1\njmp -439\njmp -310\nacc +7\nacc +18\njmp -58\nnop -444\njmp -423\nacc -5\njmp -40\nacc -14\nacc -11\nnop -283\njmp -122\nacc +13\nacc +5\nnop -259\nacc +12\njmp +1"

readInt :: T.Text -> Int
readInt t =
  let xs = T.unpack t
      sign = if head xs == '-' then -1 else 1
  in sign * (read $ tail xs)

instructions :: Array Int (T.Text, Int)
instructions = listArray (0, (length instr) - 1) instr
  where
    instr = map (\x -> let typeval = T.words x in (typeval !! 0, readInt $ typeval !! 1)) lines
    lines = T.splitOn "\n" input

count = snd $ bounds instructions

-- Execution Result, a program can either terminate or hang
data ER = Termination Int (S.Set Int) | Hang Int (S.Set Int) deriving Show

runInstructions :: Array Int (T.Text, Int) -> (Int, S.Set Int) -> Int -> ER
runInstructions instr (acc, ran) i =
  if i > count
    then Termination acc ran
    else case instr ! i of
      ("nop", _) -> runInstructions instr (acc, S.insert i ran) (i + 1)
      ("acc", val) -> runInstructions instr (acc + val, S.insert i ran) (i + 1)
      ("jmp", val) ->
        let nexti = i + val
        in if S.member nexti ran
          then Hang acc ran
          else runInstructions instr (acc, S.insert i ran) nexti

hangResult = runInstructions instructions (0, S.empty) 0
executionPath = case hangResult of
  Hang _ ran -> ran
  _ -> error "shouldn't happen"
susInstructions = filter (\(_, (t, _)) -> t /= "acc") $ S.foldl (\list i -> (i, instructions ! i):list) [] $ executionPath

findTerminatingInstructions :: Array Int (T.Text, Int) -> [(Int, (T.Text, Int))] -> [Maybe (Array Int (T.Text, Int))]
findTerminatingInstructions is l = do
  (i, (t, v)) <- l
  let newIs = is // [(i, (if t == "jmp" then "nop" else "jmp", v))]
  pure $ case runInstructions newIs (0, S.empty) i of
    Termination _ _ -> Just newIs
    _ -> Nothing

fixed = head $ catMaybes $ findTerminatingInstructions instructions susInstructions

ans = runInstructions fixed (0, S.empty) 0
