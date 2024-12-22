//
//  Pos.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

struct Pos: Hashable, CustomDebugStringConvertible {
    var x: Int
    var y: Int

    var debugDescription: String {
        return "(\(x),\(y))"
    }
}

func +(lhs: Pos, rhs: Pos) -> Pos {
    Pos(x: lhs.x + rhs.x,
        y: lhs.y + rhs.y)
}

func -(lhs: Pos, rhs: Pos) -> Pos {
    Pos(x: lhs.x - rhs.x,
        y: lhs.y - rhs.y)
}

func *(lhs: Pos, rhs: Int) -> Pos {
    Pos(x: lhs.x * rhs,
        y: lhs.y * rhs)
}

func +(lhs: Pos, rhs: Direction) -> Pos {
    Pos(x: lhs.x + rhs.offset.x,
        y: lhs.y + rhs.offset.y)
}

func -(lhs: Pos, rhs: Direction) -> Pos {
    Pos(x: lhs.x - rhs.offset.x,
        y: lhs.y - rhs.offset.y)
}
