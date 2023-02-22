module PE3 where

data Cell = SpaceCraft Int | Sand | Rock Int | Pit deriving (Eq, Read, Show)

type Grid = [[Cell]]
type Coordinate = (Int, Int)

data Move = North | East | South | West | PickUp | PutDown deriving (Eq, Read, Show)

data Robot = Robot { name :: String,
                     location :: Coordinate,
                     capacity :: Int,
                     energy :: Int,
                     storage :: Int } deriving (Read, Show)

-------------------------------------------------------------------------------------------
--------------------------------- DO NOT CHANGE ABOVE -------------------------------------
------------- DUMMY IMPLEMENTATIONS ARE GIVEN TO PROVIDE A COMPILABLE TEMPLATE ------------
------------------- REPLACE THEM WITH YOUR COMPILABLE IMPLEMENTATIONS ---------------------
-------------------------------------------------------------------------------------------
-------------------------------------- PART I ---------------------------------------------

isInGrid :: Grid -> Coordinate -> Bool
isInGrid grid coor 
                  | ((fst coor) < 0 || (snd coor) < 0)  = False
                  | ((fst coor) < xmax && (snd coor) < ymax)  = True
                  | otherwise = False
                  where xmax = length (head grid)
                        ymax = length grid

-------------------------------------------------------------------------------------------

totalCount :: Grid -> Int

totalCount [] = 0
totalCount (y:ys) = helper_counter y + totalCount ys


helper_counter :: [Cell] -> Int
helper_counter [] = 0
helper_counter (x:xs) = let rockIncrement = if (fst (isRock x))
                                              then (snd (isRock x))
                                            else
                                              0
                        in rockIncrement + helper_counter xs


isRock :: Cell -> (Bool,Int)
isRock (Rock x) = (True,x)
isRock _ = (False,0)


-------------------------------------------------------------------------------------------

coordinatesOfPits :: Grid -> [Coordinate]
coordinatesOfPits grid =sorter_tuple (helper_coorPitsy (0,0) grid)


helper_coorPitsy :: Coordinate -> Grid -> [Coordinate]
helper_coorPitsy _ [] = []
helper_coorPitsy (x,y) (c:cs) = helper_Pitcoor (x,y) c ++ helper_coorPitsy (x,y+1) cs


helper_Pitcoor :: Coordinate -> [Cell] -> [Coordinate]
helper_Pitcoor _ [] = []
helper_Pitcoor (x,y) (c:cs) = let pitcoor = if (isPit c)
                                            then [(x,y)]
                                          else
                                            []
                            in pitcoor ++ helper_Pitcoor (x+1,y) cs

isPit :: Cell -> Bool
isPit (Pit) = True
isPit _ = False


sorter_tuple :: [Coordinate] -> [Coordinate]
sorter_tuple [] = []
sorter_tuple (x:xs) = (sorter_tuple left) ++ [x] ++ (sorter_tuple right)
    where
        left = filter (< x) xs
        right = filter (>= x) xs

-------------------------------------------------------------------------------------------

tracePath :: Grid -> Robot -> [Move] -> [Coordinate]
tracePath grid robot moves = move_helper (location robot) grid robot moves (energy robot)

 
move_helper :: Coordinate -> Grid -> Robot -> [Move] -> Int -> [Coordinate]
move_helper _ _ _ [] _ = []
move_helper (x,y) grid robot (c:cs) energy =  let pos  =  result_of_move (x,y) grid robot c energy
                                              in [(fst pos)] ++ move_helper (fst pos) grid robot cs (if (energy-(snd pos)) > 0 then (energy-(snd pos)) else 0 )


result_of_move :: Coordinate -> Grid -> Robot -> Move -> Int -> (Coordinate,Int)
result_of_move (x,y) grid robot c energy
                    | c == North =if (energy == 0 )
                                    then ((x,y),0)
                                  else
                                    if (elem (x,y) pitList || not (isInGrid grid (x,y-1)))
                                      then ((x,y),1)
                                    else
                                      ((x,y-1),1)
                    | c == South =if (energy == 0 )
                                    then ((x,y),0)
                                  else
                                    if (elem (x,y) pitList || not (isInGrid grid (x,y+1)))
                                      then ((x,y),1)
                                    else
                                      ((x,y+1),1)
                    | c == East  =if (energy == 0 )
                                    then ((x,y),0)
                                  else
                                    if (elem (x,y) pitList || not (isInGrid grid (x+1,y)))
                                      then ((x,y),1)
                                    else
                                      ((x+1,y),1)
                    | c == West  =if (energy == 0 )
                                    then ((x,y),0)
                                  else
                                    if (elem (x,y) pitList || not (isInGrid grid (x-1,y)))
                                      then ((x,y),1)
                                    else
                                      ((x-1,y),1)
                    | c == PickUp  = ((x,y),5)
                    | c == PutDown = ((x,y),3)
                    where
                      pitList = coordinatesOfPits grid


------------------------------------- PART II ----------------------------------------------

energiseRobots :: Grid -> [Robot] -> [Robot]
energiseRobots grid [] = []
energiseRobots  grid (x:xs) = (energiseRobots_robot grid x) ++ energiseRobots  grid xs
 
 
energiseRobots_robot :: Grid -> Robot -> [Robot]
energiseRobots_robot grid robot = let gain = max 0 (100 - ( abs(  (fst (location robot)) - (fst (coordinatesOfSS grid))  ) + abs(  (snd (location robot)) - (snd (coordinatesOfSS grid))  )) * 20)
                                  in [(ch_energy robot gain)]

ch_energy robot x  = Robot { name = (name robot), location = (location robot) , capacity = (capacity robot) , energy = if (energy robot + x) > 100 then 100 else (energy robot + x) , storage = (storage robot)}


--cordinates of SpaceCraft
coordinatesOfSS :: Grid -> Coordinate
coordinatesOfSS grid = head (helper_coorSSy (0,0) grid)


helper_coorSSy :: Coordinate -> Grid -> [Coordinate]
helper_coorSSy _ [] = []
helper_coorSSy (x,y) (c:cs) = helper_SScoor (x,y) c ++ helper_coorSSy (x,y+1) cs


helper_SScoor :: Coordinate -> [Cell] -> [Coordinate]
helper_SScoor _ [] = []
helper_SScoor (x,y) (c:cs) = let sscoor = if (isSS c)
                                            then [(x,y)]
                                          else
                                            []
                            in sscoor ++ helper_SScoor(x+1,y) cs

isSS :: Cell -> Bool
isSS (SpaceCraft x) = True
isSS _ = False

-------------------------------------------------------------------------------------------

applyMoves :: Grid -> Robot -> [Move] -> (Grid, Robot)
applyMoves grid robot moves = (move1_helper grid robot moves)



move1_helper :: Grid -> Robot -> [Move] -> (Grid,Robot)
move1_helper grid robot []  = (grid,robot)
move1_helper grid robot (c:cs) = move1_helper newgrid newrobot cs
                                 where (newrobot,newgrid) = (robot_move (location robot) grid robot c (energy robot))





--let newrobot = (robot_move (location robot) grid robot c (energy robot))
    --                            in move1_helper grid newrobot cs




robot_move :: Coordinate -> Grid -> Robot -> Move -> Int -> (Robot,Grid)
robot_move (x,y) grid robot c energy
                  | c == North =if (energy == 0 )
                                  then (robot,grid)
                                else
                                  if (elem (x,y) pitList || not (isInGrid grid (x,y-1)))
                                    then ((ch_energy1 (robot) (-1)),grid)
                                  else
                                    (ch_locationN robot,grid)
                  | c == South =if (energy == 0 )
                                  then (robot,grid)
                                else
                                  if (elem (x,y) pitList || not (isInGrid grid (x,y+1)))
                                    then ((ch_energy1 (robot) (-1)),grid)
                                  else
                                    (ch_locationS robot,grid)
                  | c == East  =if (energy == 0 )
                                  then (robot,grid)
                                else
                                  if (elem (x,y) pitList || not (isInGrid grid (x+1,y)))
                                    then ((ch_energy1 (robot) (-1)),grid)
                                  else
                                    (ch_locationE robot,grid)
                  | c == West  =if (energy == 0 )
                                  then (robot,grid)
                                else
                                  if (elem (x,y) pitList || not (isInGrid grid (x-1,y)))
                                    then ((ch_energy1 (robot) (-1)),grid)
                                  else
                                    (ch_locationW robot,grid)
                  | c == PickUp  =if (energy < 5)
                                   then (robot,grid)
                                  else
                                   if ( (helper_counter_rocks grid (x,y)) > 0 && storage robot < capacity robot)
                                    then (ch_Pickup robot,change_grid_rock (x,y) grid)
                                   else
                                    ((ch_energy1 (robot) (-5)),grid)
                  | c == PutDown =if (energy < 3)
                                   then (robot,grid)
                                  else
                                   if ( storage robot > 0)
                                    then (ch_PutDown robot,change_grid_sc (x,y) grid)
                                   else
                                    ((ch_energy1 (robot) (-3)),grid)
                  where
                    pitList = coordinatesOfPits grid




change_grid_rock:: Coordinate -> Grid -> Grid
change_grid_rock (x,y) prevgrid = (take y prevgrid) ++ [(take x (prevgrid!!y)) ++ [dec_rock_num (prevgrid!!y!!x)] ++ drop (x+1) (prevgrid!!y)] ++ (drop (y+1) prevgrid)

change_grid_sc:: Coordinate -> Grid -> Grid
change_grid_sc (x,y) prevgrid = (take y prevgrid) ++ [(take x (prevgrid!!y)) ++ [inc_rock_num (prevgrid!!y!!x)] ++ drop (x+1) (prevgrid!!y)] ++ (drop (y+1) prevgrid)


dec_rock_num :: Cell -> Cell
dec_rock_num (Rock n) = (Rock (n-1))

inc_rock_num :: Cell -> Cell
inc_rock_num (SpaceCraft n) = (SpaceCraft (n+1))





helper_counter_rocks :: Grid -> Coordinate -> Int
helper_counter_rocks grid (x,y) = rocksleft a
                                  where a = ((grid!!y)!!x)


rocksleft :: Cell -> Int
rocksleft (Rock x) = x

ch_Pickup robot = Robot { name = (name robot), location = location robot , capacity = (capacity robot) , energy = (energy robot) - 5  , storage = (storage robot)+1}

ch_PutDown robot = Robot { name = (name robot), location = location robot , capacity = (capacity robot) , energy = (energy robot) - 3  , storage = (storage robot)-1}


move_robot (x,y) (c,d) =  if c=='x'
                            then (x+d,y)
                          else
                            (x,y+d)


ch_locationN robot = Robot { name = (name robot), location = newLocation , capacity = (capacity robot) , energy = (energy robot) - 1  , storage = (storage robot)}
      where newLocation = move_robot (location robot) ('y',-1)
ch_locationS robot = Robot { name = (name robot), location = newLocation , capacity = (capacity robot) , energy = (energy robot) - 1  , storage = (storage robot)}
      where newLocation = move_robot (location robot) ('y',1)
ch_locationE robot = Robot { name = (name robot), location = newLocation , capacity = (capacity robot) , energy = (energy robot) - 1  , storage = (storage robot)}
      where newLocation = move_robot (location robot) ('x',1)
ch_locationW robot = Robot { name = (name robot), location = newLocation , capacity = (capacity robot) , energy = (energy robot) - 1  , storage = (storage robot)}
      where newLocation = move_robot (location robot) ('x',-1)


ch_energy1 robot x  = Robot { name = (name robot), location = (location robot) , capacity = (capacity robot) , energy = if (energy robot + x) > 100 then 100 else (energy robot + x) , storage = (storage robot)}