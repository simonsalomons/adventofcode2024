//
//  Day15.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

func day15() {
    let content = content(file: "input15")

    let components = content.split(separator: "\n\n", omittingEmptySubsequences: true)

    enum Space: CustomDebugStringConvertible {
        case wall
        case box
        case lBox
        case rBox
        case robot
        case empty

        var debugDescription: String {
            switch self {
            case .wall:
                return "#"
            case .box:
                return "O"
            case .lBox:
                return "["
            case .rBox:
                return "]"
            case .robot:
                return "@"
            case .empty:
                return "."
            }
        }

        init(_ character: Character) {
            switch character {
            case "#":
                self = .wall
            case "O":
                self = .box
            case "@":
                self = .robot
            default:
                self = .empty
            }
        }
    }

    var grid = components[0].grid({ Space($0) })

    // For Part 2
    grid = grid.map { spaces in
        spaces.flatMap { space -> [Space] in
            switch space {
            case .robot:
                return [.robot, .empty]
            case .box:
                return [.lBox, .rBox]
            default:
                return [space, space]
            }
        }
    }

    let moves = components[1].lines().joined().compactMap({ Direction($0) })
    var robotPos = grid.first(where: { $1 == .robot })!.0

    /// Returns nil if cannot be pushed, empty array if nothing to push
    func boxesToPush(at pos: Pos, dir: Direction) -> [Pos]? {

        if pos == Pos(x: 13, y: 3) && dir == .down {
            print("stop")
        }

        let pos = pos + dir

        guard let space = grid.at(pos) else { return nil }

        switch space {
        case .box:
            guard let nextBoxes = boxesToPush(at: pos, dir: dir) else { return nil }
            return [pos] + nextBoxes
        case .lBox:
            let rBoxPos = pos + Direction.right
            switch dir {
            case .up, .down:
                guard let nextLBoxes = boxesToPush(at: pos, dir: dir),
                      let nextRBoxes = boxesToPush(at: rBoxPos, dir: dir) else {
                    return nil
                }
                return [pos, rBoxPos] + nextLBoxes + nextRBoxes
            case .right:
                guard let nextBoxes = boxesToPush(at: rBoxPos, dir: dir) else { return nil }
                return [pos, rBoxPos] + nextBoxes
            case .left:
                fatalError("Impossible to start pushing the left side of a box to the left")
//                guard let nextBoxes = boxesToPush(at: pos, dir: dir) else { return nil }
//                return [pos] + nextBoxes
            default:
                fatalError("Impossible direction in this challenge")
            }

        case .rBox:
            let lBoxPos = pos + Direction.left
            switch dir {
            case .up, .down:
                guard let nextLBoxes = boxesToPush(at: lBoxPos, dir: dir),
                      let nextRBoxes = boxesToPush(at: pos, dir: dir) else {
                    return nil
                }
                return [pos, lBoxPos] + nextLBoxes + nextRBoxes
            case .left:
                guard let nextBoxes = boxesToPush(at: lBoxPos, dir: dir) else { return nil }
                return [pos, lBoxPos] + nextBoxes
            case .right:
                fatalError("Impossible to start pushing the right side of a box to the right")
//                guard let nextBoxes = boxesToPush(at: pos, dir: dir) else { return nil }
//                return [pos] + nextBoxes
            default:
                fatalError("Impossible direction in this challenge")
            }

        case .wall:
            return nil
        case .empty:
            return []
        case .robot:
            return nil
        }
    }

    grid.print()
    print()

    for move in moves {
        guard let boxesToPush = boxesToPush(at: robotPos, dir: move) else {
//            print("Can't move \(move.debugCharacter)")
//            print()
            continue
        }

        var pushedBoxes: Set<Pos> = []

//        print("Moving \(move.debugCharacter)")

        for box in boxesToPush.reversed() {
            guard !pushedBoxes.contains(box) else { continue }
            pushedBoxes.insert(box)

            grid.swap(pos: box, andPos: box + move)
        }
        let nextRobotPos = robotPos + move
        grid.swap(pos: robotPos, andPos: nextRobotPos)
        robotPos = nextRobotPos

//        grid.print()
//        print()
    }

    grid.print()
    print()

    var sum = 0
    grid.loop { pos, element in
        switch element {
        case .box, .lBox:
            sum += pos.y * 100 + pos.x
        default:
            return
        }
    }
    print(sum)
}
