//
//  Direction.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

enum Direction: Int, CustomDebugStringConvertible {
    case right, left, up, down, upRight, upLeft, downRight, downLeft

    static var cardinals: [Direction] {
        [.up, .right, .down, .left]
    }
    static var all: [Direction] {
        [.right, .left, .up, .down, .upRight, .upLeft, .downRight, .downLeft]
    }

    var opposite: Direction {
        switch self {
        case .right:
                .left
        case .left:
                .right
        case .up:
                .down
        case .down:
                .up
        case .upRight:
                .downLeft
        case .upLeft:
                .downRight
        case .downLeft:
                .upRight
        case .downRight:
                .upLeft
        }
    }

    var offset: Pos {
        switch self {
        case .right:
            Pos(x: 1, y: 0)
        case .downRight:
            Pos(x: 1, y: 1)
        case .down:
            Pos(x: 0, y: 1)
        case .downLeft:
            Pos(x: -1, y: 1)
        case .left:
            Pos(x: -1, y: 0)
        case .upLeft:
            Pos(x: -1, y: -1)
        case .up:
            Pos(x: 0, y: -1)
        case .upRight:
            Pos(x: 1, y: -1)
        }
    }

    var debugCharacter: String {
        switch self {
        case .left:
            return "<"
        case .right:
            return ">"
        case .up:
            return "^"
        case .down:
            return "v"
        case .upRight:
            return "↗"
        case .downRight:
            return "↘"
        case .upLeft:
            return "↖"
        case .downLeft:
            return "↙"
        }
    }

    var debugDescription: String {
        debugCharacter
    }

    init?(_ character: Character) {
        switch character {
        case "<":
            self = .left
        case ">":
            self = .right
        case "^":
            self = .up
        case "v":
            self = .down
        default:
            return nil
        }
    }

    mutating func rotate90() {
        switch self {
        case .up:
            self = .right
        case .right:
            self = .down
        case .down:
            self = .left
        case .left:
            self = .up
        case .upRight:
            self = .downRight
        case .downRight:
            self = .downLeft
        case .downLeft:
            self = .upLeft
        case .upLeft:
            self = .upRight
        }
    }

    mutating func rotateMinus90() {
        switch self {
        case .up:
            self = .left
        case .right:
            self = .up
        case .down:
            self = .right
        case .left:
            self = .down
        case .upRight:
            self = .upLeft
        case .downRight:
            self = .upRight
        case .downLeft:
            self = .downRight
        case .upLeft:
            self = .downLeft
        }
    }
}
