module PE2 where
import Data.List

---------------------------------------------------------------------------------------------
------------------------- DO NOT CHANGE ABOVE OR FUNCTION SIGNATURES-------------------------
--------------- DUMMY IMPLEMENTATIONS ARE GIVEN TO PROVIDE A COMPILABLE TEMPLATE ------------
--------------------- REPLACE THEM WITH YOUR COMPILABLE IMPLEMENTATIONS ---------------------
---------------------------------------------------------------------------------------------

-- Note: undefined is a value that causes an error when evaluated. Replace it with
-- a viable definition! Name your arguments as you like by changing the holes: _

--------------------------
-- Part I: Time to inf up!

-- naturals: The infinite list of natural numbers. That's it!
naturals :: [Integer]
naturals = [0..]

-- interleave: Interleave two lists, cutting off on the shorter list.
interleave :: [a] -> [a] -> [a]
interleave x [] = []
interleave [] y = []
interleave (x:xs) (y:ys) = x : y : interleave xs ys

-- integers: The infinite list of integers. Ordered as [0, -1, 1, -2, 2, -3, 3, -4, 4...].
integers :: [Integer]
integers = 0:[ x  | y <- [1..], x <- [-y, y]]


--------------------------------
-- Part II: SJSON Prettification

-- splitOn: Split string on first occurence of character.
splitOn :: Char -> String -> (String, String)
splitOn c [] = ([],[])
splitOn c text =  if a == []
                    then (text,"")
                  else
                    (take (head a) text, drop (head (a) +1) text)
                  where a = elemIndices c text


-- tokenizeS: Transform an SJSON string into a list of tokens.
specialch = ['{', '}', ':',',']
quote = "'"
otherch = [' ','\n','\t']

tokenizeS :: String -> [String]
tokenizeS [] = []
tokenizeS (c:cs)
   | c == '}'  =  "}" : remainder 
   | c == '{'  =  "{" : remainder 
   | c == ':'  =  ":" : remainder  
   | c == ','  =  "," : remainder 
   | elem c otherch  = remainder 
   | elem c quote = fst(splitOn '\'' cs) : tokenizeS (snd (splitOn '\'' cs) )
   | otherwise = error "Sorry"
   where
    remainder = tokenizeS cs
    


-- prettifyS: Prettify SJSON, better tokenize first!
prettifyS :: String -> String
prettifyS txt = prettyify_helper (tokenizeS txt)


prettyify_helper:: [String] -> String
prettyify_helper [] = ""
prettyify_helper (c:cs) 
   | c == "{"  =  "{" ++ "\n" ++ "    " ++ remainder 
   | c == "}"  =  "\n" ++ "}"  ++ remainder 
   | c == ":"  =  ":" ++ " " ++ remainder  
   | c == ","  =  "," ++ "\n" ++ "    " ++ remainder 
   | otherwise = ['\''] ++ c ++ ['\''] ++ remainder
   where
    remainder = prettyify_helper cs



-- Good luck to you, friend and colleague!

