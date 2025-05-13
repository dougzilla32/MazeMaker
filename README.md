# MazeMaker

A Swift program that generates random mazes using an elegant algorithm.

## What it does

This program creates mazes using an effective approach:

1. Start with a grid of empty cells surrounded by a border
2. Randomly select valid starting points and directions
3. Mark paths through the maze with alternating X and O characters
4. Continue until no more valid paths can be created

## Example Output

```
+-+-+-+-+-+
|         |
+ +-+-+ + +
|     |   |
+-+-+ +-+ +
|     |   |
+ +-+ + +-+
|   |     |
+-+-+-+-+-+
```

## Usage

Run the program with:

```swift
// Generate and display a maze of size 10
printMazeLines(generateMaze(n: 10))
```

You can adjust the size parameter to create smaller or larger mazes.

## How it works

The code leverages several key Swift features:
- Enums for maze states (X, O, blank) and directions (N, S, E, W)
- A coordinate system to track positions
- Random selection to create unique mazes each time

A neat maze generator that demonstrates practical algorithm implementation!
