module PE4 where

import Data.Maybe -- up to you if you want to use it or not

-- Generic DictTree definition with two type arguments
data DictTree k v = Node [(k, DictTree k v)] | Leaf v deriving Show

-- Lightweight Char wrapper as a 'safe' Digit type
newtype Digit = Digit Char deriving (Show, Eq, Ord) -- derive equality and comparison too!

-- Type aliases
type DigitTree = DictTree Digit String
type PhoneNumber = [Digit]


---------------------------------------------------------------------------------------------
------------------------- DO NOT CHANGE ABOVE OR FUNCTION SIGNATURES-------------------------
--------------- DUMMY IMPLEMENTATIONS ARE GIVEN TO PROVIDE A COMPILABLE TEMPLATE ------------
--------------------- REPLACE THEM WITH YOUR COMPILABLE IMPLEMENTATIONS ---------------------
---------------------------------------------------------------------------------------------


----------
-- Part I:
-- Some Maybe fun! Basic practice with an existing custom datatype.

-- toDigit: Safely convert a character to a digit
toDigit :: Char -> Maybe Digit
toDigit c = if (c >= '0') && (c  <= '9')
              then Just (Digit c)
            else
              Nothing

-- toDigits: Safely convert a bunch of characters to a list of digits.
--           Particularly, an empty string should fail.
toDigits :: String -> Maybe PhoneNumber
toDigits [] = Nothing
toDigits str =if (scanner (str))
                then Just (helper_convert str)
              else 
                Nothing

scanner  :: String -> Bool
scanner str = if ( filtered == str)
                then True
              else
                False
              where
                filtered = filter ( <= '9') (filter (>= '0') str)
              
helper_convert [] = []
helper_convert (x:xs) = [extract_value(w)] ++ (helper_convert xs)
                        where
                          w = (toDigit x)


extract_value::Maybe a -> a
extract_value (Just a) = a


-----------
-- Part II:
-- Some phonebook business.

-- numContacts: Count the number of contacts in the phonebook...
numContacts :: DigitTree -> Int
numContacts (Node []) = 0
numContacts (Leaf v) = 1
numContacts (Node (x:xs)) = numContacts(snd x) + numContacts (Node xs)
    
-- getContacts: Generate the contacts and their phone numbers in order given a tree. 
getContacts :: DigitTree -> [(PhoneNumber, String)]
getContacts tree = (getContactName (path tree) tree)

getContactName ::  [PhoneNumber] -> DigitTree -> [(PhoneNumber, String)]
getContactName [] tree = []
getContactName (x:xs) tree = [(helpera x tree x)] ++ (getContactName xs tree)

path :: DigitTree -> [PhoneNumber]
path (Node []) = []
path (Leaf v) = [[]]
path (Node(x:xs)) = map ((fst x):) (path (snd x)) ++ (path (Node xs))


helpera :: PhoneNumber -> DigitTree -> PhoneNumber -> (PhoneNumber, String)
helpera (x:xs) (Node a) intactnum = if (isLeaf (snd (a !! index)))
                            then (intactnum, getName (snd (a !! index)))
                          else
                            helpera (xs) (snd (a !! index)) intactnum
                          where index = (index_finder (fstlist) (x) (0))
                                fstlist = [   fst q  | q <- a  ]
                                
index_finder [] x ind = -1
index_finder (c:cs) x ind = if (c == x)
                              then ind
                            else
                              index_finder (cs) x (ind+1)

isLeaf :: DigitTree -> Bool
isLeaf (Leaf v) = True
isLeaf (Node a) = False

getName :: DigitTree -> String
getName (Leaf v) = v

-- autocomplete: Create an autocomplete list of contacts given a prefix
-- e.g. autocomplete "32" areaCodes -> 
--      [([Digit '2'], "Adana"), ([Digit '6'], "Hatay"), ([Digit '8'], "Osmaniye")]
autocomplete :: String -> DigitTree -> [(PhoneNumber, String)]
autocomplete str tree = if ((toDigits str) == Nothing)
                          then []
                        else
                          (helper_autocomplete (extract_value (toDigits str)) (tree) (length str) 0 tree)


helper_autocomplete :: PhoneNumber -> DigitTree -> Int -> Int -> DigitTree -> [(PhoneNumber, String)]
helper_autocomplete (x:xs) (Node a) len curr tree |  index == -1  = []
                                                  | (isLeaf (snd (a !! index))) && not (curr+1 == len) = []
                                                  | (isLeaf (snd (a !! index))) = [([],getName (snd (a !! index)))]
                                                  | (curr+1 == len) && (not (index == -1)) =  getContacts((snd (a !! index)))
                                                  |  otherwise  = helper_autocomplete (xs) (snd (a !! index)) len (curr+1) (snd (a !! index))
                                                      where index = (index_finder (fstlist) (x) (0))
                                                            fstlist = [   fst q  | q <- a  ]






-----------
-- Example Trees
-- Two example trees to play around with, including THE exampleTree from the text. 
-- Feel free to delete these or change their names or whatever!

exampleTree :: DigitTree
exampleTree = Node [
    (Digit '1', Node [
        (Digit '3', Node [
            (Digit '7', Node [
                (Digit '8', Leaf "Jones")])]),
        (Digit '5', Leaf "Steele"),
        (Digit '9', Node [
            (Digit '1', Leaf "Marlow"),
            (Digit '2', Node [
                (Digit '3', Leaf "Stewart")])])]),
    (Digit '3', Leaf "Church"),
    (Digit '7', Node [
        (Digit '2', Leaf "Curry"),
        (Digit '7', Leaf "Hughes")])]

areaCodes :: DigitTree
areaCodes = Node [
    (Digit '3', Node [
        (Digit '1', Node [
            (Digit '2', Leaf "Ankara")]),
        (Digit '2', Node [
            (Digit '2', Leaf "Adana"),
            (Digit '6', Leaf "Hatay"),
            (Digit '8', Leaf "Osmaniye")])]),
    (Digit '4', Node [
        (Digit '6', Node [
            (Digit '6', Leaf "Artvin")])])]

