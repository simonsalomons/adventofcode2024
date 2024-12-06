//
//  day6.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 06/12/2024.
//

import Foundation

public func day6() {
    let content = content(file: "input6")

    struct Pos: Hashable {
        let x: Int
        let y: Int
    }
    enum Space: CustomDebugStringConvertible, Equatable {
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
                    switch directions.first! {
                    case .left:
                        return "<"
                    case .right:
                        return ">"
                    case .up:
                        return "^"
                    case .down:
                        return "v"
                    }
                } else {
                    return "+"
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

    enum Direction {
        case up, right, down, left

        var x: Int {
            switch self {
            case .right:
                return 1
            case .left:
                return -1
            case .up, .down:
                return 0
            }
        }
        var y: Int {
            switch self {
            case .up:
                return -1
            case .down:
                return 1
            case .left, .right:
                return 0
            }
        }

        mutating func rotate() {
            switch self {
            case .up:
                self = .right
            case .right:
                self = .down
            case .down:
                self = .left
            case .left:
                self = .up
            }
        }
    }

    var lines = content
        .components(separatedBy: "\n")
        .compactMap({ line -> [Space]? in
            guard !line.isEmpty else { return nil }
            return line.map({ Space(character: $0) })
        })

    var guardPos = Pos(x: 0, y: 0)
    var guardDirection: Direction = .up

    lineLoop: for y in 0..<lines.count {
        for x in 0..<lines[y].count {
            if case let .guard(direction) = lines[y][x] {
                guardPos = Pos(x: x, y: y)
                guardDirection = direction
                lines[y][x] = .visited([direction])
                break lineLoop
            }
        }
    }

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
            let nextPos = Pos(x: pos.x + direction.x, y: pos.y + direction.y)

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
                direction.rotate()

            case .guard: // Impossible
                break
            }
        }
        return .impossible
    }

    var ranMaze: [[Space]] = []

    switch run(through: lines, pos: guardPos, direction: guardDirection) {
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

                var newMaze = lines
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
