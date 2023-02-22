# search.py
# ---------
# Licensing Information:  You are free to use or extend these projects for
# educational purposes provided that (1) you do not distribute or publish
# solutions, (2) you retain this notice, and (3) you provide clear
# attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
# 
# Attribution Information: The Pacman AI projects were developed at UC Berkeley.
# The core projects and autograders were primarily created by John DeNero
# (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# Student side autograding was added by Brad Miller, Nick Hay, and
# Pieter Abbeel (pabbeel@cs.berkeley.edu).


"""
In search.py, you will implement generic search algorithms which are called by
Pacman agents (in searchAgents.py).
"""

from inspect import stack
import queue
from turtle import pos
import util

class SearchProblem:
    """
    This class outlines the structure of a search problem, but doesn't implement
    any of the methods (in object-oriented terminology: an abstract class).

    You do not need to change anything in this class, ever.
    """

    def getStartState(self):
        """
        Returns the start state for the search problem.
        """
        util.raiseNotDefined()

    def isGoalState(self, state):
        """
          state: Search state

        Returns True if and only if the state is a valid goal state.
        """
        util.raiseNotDefined()

    def getSuccessors(self, state):
        """
          state: Search state

        For a given state, this should return a list of triples, (successor,
        action, stepCost), where 'successor' is a successor to the current
        state, 'action' is the action required to get there, and 'stepCost' is
        the incremental cost of expanding to that successor.
        """
        util.raiseNotDefined()

    def getCostOfActions(self, actions):
        """
         actions: A list of actions to take

        This method returns the total cost of a particular sequence of actions.
        The sequence must be composed of legal moves.
        """
        util.raiseNotDefined()


def tinyMazeSearch(problem):
    """
    Returns a sequence of moves that solves tinyMaze.  For any other maze, the
    sequence of moves will be incorrect, so only use this for tinyMaze.
    """
    from game import Directions
    s = Directions.SOUTH
    w = Directions.WEST
    return  [s, s, w, s, w, w, s, w]


def SearchAlgorithm(problem, queue_strategy, heuristic):

    path = []                                   #Final list of directions to goal
    visited = []                                #List of states that have been visited
    if (queue_strategy == "DFS"):
        state_queue = util.Stack()                  #State stack to manage expand method
        current_path = util.Stack()                 #Stack to maintain path from start to goal
        state_queue.push(problem.getStartState())   #start from initial state
    elif (queue_strategy == "BFS"):
        state_queue = util.Queue()                  #State stack to manage expand method
        current_path = util.Queue()                #Stack to maintain path from start to goal
        state_queue.push(problem.getStartState())   #start from initial state
    else:
        state_queue  =   util.PriorityQueue()                   #State stack to manage expand method
        current_path =  util.PriorityQueue()                    #Stack to maintain path from start to goal
        state_queue.push(problem.getStartState(),0)             #start from initial state

    current_state = state_queue.pop()

    while not problem.isGoalState(current_state): 
            if current_state not in visited:
                visited.append(current_state)
                successors = problem.getSuccessors(current_state)
                for successor,dir,cost in successors:
                    tempPath = path + [dir]
                    if (queue_strategy in ["DFS","BFS"]):
                        state_queue.push(successor)
                        current_path.push(tempPath)
                    else:
                        total_cost = problem.getCostOfActions(tempPath) 
                        if successor not in visited:
                            if queue_strategy == "A*":
                                total_cost += heuristic(successor,problem)
                            current_path.push(tempPath,total_cost)
                            state_queue.push(successor,total_cost)

            if(state_queue.isEmpty() == True):
                return None
            path = current_path.pop()
            current_state = state_queue.pop()

    return path


def depthFirstSearch(problem):
    """
    Search the deepest nodes in the search tree first.

    Your search algorithm needs to return a list of actions that reaches the
    goal. Make sure to implement a graph search algorithm.

    To get started, you might want to try some of these simple commands to
    understand the search problem that is being passed in:

    print("Start:", problem.getStartState())
    print("Is the start a goal?", problem.isGoalState(problem.getStartState()))
    print("Start's successors:", problem.getSuccessors(problem.getStartState()))
    """
    "*** YOUR CODE HERE ***"
    #util.raiseNotDefined()
    return SearchAlgorithm(problem, "DFS", None)


'''
    state_stack = util.Stack()   #State stack to manage expand method
    path = []                    #Final list of directions to goal
    visited = []                 #List of states that have been visited
    current_path = util.Stack()                 #Stack to maintain path from start to goal
    
    state_stack.push(problem.getStartState())   #start from initial state
    current_state = state_stack.pop()

    while not problem.isGoalState(current_state): 
        if current_state not in visited:
            visited.append(current_state)
            #print(visited)
            successors = problem.getSuccessors(current_state)
            for successor,dir,cost in successors:
                state_stack.push(successor)
                tempPath = path + [dir]
                current_path.push(tempPath)

        if(state_stack.isEmpty() == True):
            return None
        path = current_path.pop()
        current_state = state_stack.pop()
        #print(path)

    return path
'''


def breadthFirstSearch(problem):
    """Search the shallowest nodes in the search tree first."""
    "*** YOUR CODE HERE ***"
    #util.raiseNotDefined()
    return SearchAlgorithm(problem, "BFS", None)



def uniformCostSearch(problem):
    """Search the node of least total cost first."""
    "*** YOUR CODE HERE ***"
    #util.raiseNotDefined()
    state_queue = util.PriorityQueue()                  #State stack to manage expand method
    path = []                                           #Final list of directions to goal
    visited = []                                        #List of states that have been visited
    current_path = util.PriorityQueue()                 #Queue to maintain path from start to goal
    
    state_queue.push(problem.getStartState(),0)         #start from initial state
    current_state = state_queue.pop()

    while not problem.isGoalState(current_state): 
        if current_state not in visited:
            visited.append(current_state)
            successors = problem.getSuccessors(current_state)
            for successor,dir,cost in successors:
                tempPath = path + [dir]
                total_cost = problem.getCostOfActions(tempPath)
                if successor not in visited:
                    current_path.push(tempPath,total_cost)
                    state_queue.push(successor,total_cost)

        if(state_queue.isEmpty() == True):
            return None
        path = current_path.pop()
        current_state = state_queue.pop()

    return path
    return SearchAlgorithm(problem, "BFS", None)


def nullHeuristic(state, problem=None):
    """
    A heuristic function estimates the cost from the current state to the nearest
    goal in the provided SearchProblem.  This heuristic is trivial.
    """
    return 0

def aStarSearch(problem, heuristic=nullHeuristic):
    """Search the node that has the lowest combined cost and heuristic first."""
    "*** YOUR CODE HERE ***"
    #util.raiseNotDefined()
    state_queue = util.PriorityQueue()                  #State stack to manage expand method
    path = []                                           #Final list of directions to goal
    visited = []                                        #List of states that have been visited
    current_path = util.PriorityQueue()                 #Queue to maintain path from start to goal
    
    state_queue.push(problem.getStartState(),0)         #start from initial state
    current_state = state_queue.pop()

    while not problem.isGoalState(current_state): 
        if current_state not in visited:
            visited.append(current_state)
            successors = problem.getSuccessors(current_state)
            for successor,dir,cost in successors:
                tempPath = path + [dir]
                total_cost = problem.getCostOfActions(tempPath) + heuristic(successor,problem)
                if successor not in visited:
                    current_path.push(tempPath,total_cost)
                    state_queue.push(successor,total_cost)

        if(state_queue.isEmpty() == True):
            return None
        path = current_path.pop()
        current_state = state_queue.pop()

    return path


# Abbreviations
bfs = breadthFirstSearch
dfs = depthFirstSearch
astar = aStarSearch
ucs = uniformCostSearch

'''
from util import Stack
    fringe = Stack()                # Fringe to manage which states to expand
    fringe.push(problem.getStartState())
    visited = []                    # List to check whether state has already been visited
    path=[]                         # Final direction list
    pathToCurrent=Stack()           # Stack to maintaing path from start to a state
    currState = fringe.pop()
    while not problem.isGoalState(currState):
        if currState not in visited:
            visited.append(currState)
            successors = problem.getSuccessors(currState)
            for child,direction,cost in successors:
                fringe.push(child)
                tempPath = path + [direction]
                pathToCurrent.push(tempPath)
        currState = fringe.pop()
        path = pathToCurrent.pop()
    return path
'''