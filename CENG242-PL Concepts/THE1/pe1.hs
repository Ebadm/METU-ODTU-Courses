module PE1 where

import Text.Printf


-- This function takes a Double and rounds it to 2 decimal places as requested in the PE --
getRounded :: Double -> Double
getRounded x = read s :: Double
               where s = printf "%.2f" x

-------------------------------------------------------------------------------------------
----------------------- DO NOT CHANGE ABOVE OR FUNCTION SIGNATURES-------------------------
------------- DUMMY IMPLEMENTATIONS ARE GIVEN TO PROVIDE A COMPILABLE TEMPLATE ------------
------------------- REPLACE THEM WITH YOUR COMPILABLE IMPLEMENTATIONS ---------------------
-------------------------------------------------------------------------------------------

convertTL :: Double -> String -> Double
convertTL money currency = if currency == "USD" 
                            then getRounded (money / 8.18)
                           else
                              if currency == "EUR"
                                then  getRounded ( money / 9.62)
                              else
                                 getRounded (money / 473497.31)

-------------------------------------------------------------------------------------------

countOnWatch :: [String] -> String -> Int -> Int
countOnWatch schedule employee days = length (filter (==employee)(take days (schedule)))
-------------------------------------------------------------------------------------------
convertToDigits :: Int -> [Int]
convertToDigits n 
 | n < 1 = []
 | otherwise = convertToDigits (n `div` 10) ++ [n `mod` 10]
 
classify :: Int -> Int
classify a  
          | (a `mod` 3) == 0 = a - 1  
          | (a `mod` 4) == 0 = a * 2
          | (a `mod` 5) == 0 =  a + 3
          | otherwise = a + 4


encrypt_helper :: [Int] -> [Int]
encrypt_helper lst = [classify x | x <- lst]

single_digit_check :: [Int] -> [Int]
single_digit_check lst = [ x `mod` 10 | x <- lst]

joiner :: [Int] -> Int
joiner = read . concatMap show

encrypt :: Int -> Int
encrypt x = joiner(single_digit_check(encrypt_helper(convertToDigits(x))))




-------------------------------------------------------------------------------------------


getRate :: (Double,Int) -> Double
getRate tpl = if fst tpl >= 10000 && snd tpl >= 2 
                then 11.5/100
              else
                if fst tpl < 10000 && snd tpl >= 2
                  then 9.5/100
                else
                  if fst tpl < 10000 && snd tpl < 2
                    then 9.0/100
                  else
                    10.5/100

compoundInthelper :: (Double, Int) -> Double
compoundInthelper x = (fst x) * (1+((getRate x)/12)) ^ (12 * (snd x))


compoundInterests :: [(Double, Int)] -> [Double]
compoundInterests investments = [ getRounded(compoundInthelper x) | x <- investments]
