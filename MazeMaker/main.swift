//
//  main.swift
//  MazeMaker
//
//  Created by Doug on 4/12/22.
//

//
//  Maze Generation Algorithm
//
//  1. Starts with bounding box defined by n= number of X's on a side
//  2. Pick random valid starting X
//  3. Pick random valid direction from starting X [ N, S, E, W ]
//  4. Mark O then X from starting X in direction
//  5. Repeat back to #2 until done
//  6. Return generated maze
//
//  * Example n=3
//
//  XOXOX
//  O   O
//  X XOX
//  O   O
//  XOXOX
//
//  * Walkthrough n=4
//
//  XOXOXOX
//  O   O O
//  X X X X
//  O O   O
//  XOX XOX
//  O     O
//  XOXOXOX
//

enum MazeState {
    case X,O,B
    
    var description: String {
        switch self {
        case .X: return "X"
        case .O: return "O"
        case .B: return " "
        }
    }
}

enum Direction {
    case N,S,E,W
    
    var vector: (Int, Int) {
        switch self {
        case .N:
            return (0, -1)
        case .S:
            return (0, 1)
        case .E:
            return (1, 0)
        case .W:
            return (-1, 0)
        }
    }
    
    static let allDirections: [Direction] = [.N, .S, .E, .W]
}

struct Coord: Hashable {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

class Maze {
    var potentiallyValidX: Set<Coord>
    var grid: [[MazeState]]
    
    init(size: Int) {
        potentiallyValidX = Set<Coord>()
        grid = [[MazeState]](repeating: [MazeState](repeating: .B, count: size), count: size)
        
        var isX = true
        for i in 0..<size {
            for c in [Coord(0, i), Coord(i, 0), Coord(size-1, i), Coord(i, size-1)] {
                grid[c.x][c.y] = isX ? .X : .O

                // Include all Xs that are not corners in potentiallyValidX
                if isX && i != 0 && i != size-1 {
                    potentiallyValidX.insert(c)
                }
            }
            isX = !isX
        }

    }
}

func generateMaze(n: Int) -> [[MazeState]] {
    let maze = Maze(size: 2 * n - 1)
    
    while true {
        guard let x = maze.potentiallyValidX.randomElement() else {
            return maze.grid
        }
        if let newX = tryMarkingRandomDirection(maze, x) {
            maze.potentiallyValidX.insert(newX)
        } else {
            maze.potentiallyValidX.remove(x)
        }
    }
}

func tryMarkingRandomDirection(_ maze: Maze, _ start: Coord) -> Coord? {
    assert(maze.grid[start.x][start.y] == .X)
    
    for d in Direction.allDirections.shuffled() {
        let vector = d.vector
        let tryO = Coord(start.x + vector.0, start.y + vector.1)
        let tryX = Coord(start.x + vector.0 * 2, start.y + vector.1 * 2)
        if maze.grid[safe: tryO.x]?[safe: tryO.y] == .B && maze.grid[safe: tryX.x]?[safe: tryX.y] == .B {
            maze.grid[tryO.x][tryO.y] = .O
            maze.grid[tryX.x][tryX.y] = .X
            return tryX
        }
    }
    return nil
}

func printMaze(_ mazeState: [[MazeState]]) {
    for row in mazeState {
        for item in row {
            print(item.description, terminator: "")
        }
        print("")
    }
    print("")
}


func printMazeLines(_ mazeState: [[MazeState]]) {
    for x in 0..<mazeState.count {
        for y in 0..<mazeState[x].count {
            if mazeState[x][y] == .B {
                print(" ", terminator: "")
                continue
            }
            
            let nv = Direction.N.vector
            let sv = Direction.S.vector
            let ev = Direction.E.vector
            let wv = Direction.W.vector
            
            let n = mazeState[safe: x + nv.0]?[safe: y + nv.1]
            let s = mazeState[safe: x + sv.0]?[safe: y + sv.1]
            let e = mazeState[safe: x + ev.0]?[safe: y + ev.1]
            let w = mazeState[safe: x + wv.0]?[safe: y + wv.1]
            
            if occupied(n) && occupied(s) && !occupied(e) && !occupied(w) {
                print("-", terminator: "")
            } else if !occupied(n) && !occupied(s) && occupied(e) && occupied(w)  {
                print("|", terminator: "")
            } else {
                print("+", terminator: "")
            }
        }
        print("")
    }
    print("")
}

func occupied(_ state: MazeState?) -> Bool {
    guard let state = state else {
        return false
    }
    switch state {
    case .X, .O:
        return true
    case .B:
        return false
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

//for i in 1...20 {
//    let m = generateMaze(n: i)
////    printMaze(m)
//    printMazeLines(m)
//}

printMazeLines(generateMaze(n: 60))
