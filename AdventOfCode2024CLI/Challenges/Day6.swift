//
//  day6.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 06/12/2024.
//

import Foundation

public func day6() {
    var grid = content(file: "input6").grid({ Space(character: $0) })

    var guardPos = Pos(x: 0, y: 0)
    var guardDirection: Direction = .up

    grid.first(where: { pos, element in
        if case let .guard(direction) = element {
            guardPos = pos
            guardDirection = direction
            return true
        }
        return false
    })
    grid.set(.visited([guardDirection]), at: guardPos)

    enum MazeResult {
        case exit(stepCount: Int, maze: [[Space]])
        case loop
        case impossible
    }

    func printMaze(_ maze: [[Space]]) {
        for line in maze {
            print(line.map({ "\($0)" }).joined(separator: ""))
        }
    }

    func run(through maze: [[Space]], pos: Pos, direction: Direction) -> MazeResult {
        var maze = maze
        var pos = pos
        var direction = direction
        var stepCount = 1

        func space(at pos: Pos) -> Space? {
            guard pos.x >= 0,
                  pos.y >= 0,
                  pos.y < maze.count,
                  pos.x < maze[pos.y].count else {
                return nil
            }
            return maze[pos.y][pos.x]
        }

        while stepCount < 200_000 {
            let nextPos = pos + direction

            guard let space = space(at: nextPos) else {
                return .exit(stepCount: stepCount, maze: maze)
            }

            switch space {
            case .empty:
                pos = nextPos
                maze[pos.y][pos.x].visit(direction)
                stepCount += 1

            case let .visited(directions):
                guard !directions.contains(direction) else {
                    return .loop
                }
                pos = nextPos
                maze[pos.y][pos.x].visit(direction)

            case .wall, .timeParadoxObstruction:
                direction.rotate90()

            case .guard: // Impossible
                break
            }
        }
        return .impossible
    }

    var ranMaze: [[Space]] = []

    switch run(through: grid, pos: guardPos, direction: guardDirection) {
    case let .exit(stepCount, maze):
        ranMaze = maze
        printMaze(maze)
        print("Part 1:", stepCount)
    case .loop, .impossible:
        print("Part 1 impossible")
    }

    // Part 2

    var obstructions: Set<Pos> = []

    for y in 0..<ranMaze.count {
        for x in 0..<ranMaze[y].count {
            switch ranMaze[y][x] {
            case .visited:
                let pos = Pos(x: x, y: y)
                guard !obstructions.contains(pos) else { continue }

                var newMaze = grid
                newMaze[y][x] = .timeParadoxObstruction
                switch run(through: newMaze, pos: guardPos, direction: guardDirection) {
                case .exit:
                    break // No loop
                case .loop:
                    obstructions.insert(pos)
                case .impossible:
                    // Infinite loop
                    obstructions.insert(pos)
                }

            case .empty, .timeParadoxObstruction, .guard, .wall:
                break
            }
        }
    }

    print("Part 2:", obstructions.count)
}

// MARK: - Space

private enum Space: CustomDebugStringConvertible, Equatable {
    case empty
    case visited([Direction])
    case wall
    case `guard`(Direction)
    case timeParadoxObstruction

    init(character: Character) {
        switch character {
        case "#":
            self = .wall
        case ">":
            self = .guard(.right)
        case "<":
            self = .guard(.left)
        case "^":
            self = .guard(.up)
        case "v":
            self = .guard(.down)
        default:
            self = .empty
        }
    }

    var debugDescription: String {
        switch self {
        case .empty:
            return "."
        case let .visited(directions):
            if directions.count == 1 {
                return directions.first!.debugCharacter
            } else {
                return "*"
            }
        case .wall:
            return "#"
        case .guard:
            return "G"
        case .timeParadoxObstruction:
            return "◉"
        }
    }

    mutating func visit(_ direction: Direction) {
        switch self {
        case .empty:
            self = .visited([direction])
        case let .visited(directions):
            self = .visited(directions + [direction])
        case .wall, .guard, .timeParadoxObstruction:
            break
        }
    }
}
