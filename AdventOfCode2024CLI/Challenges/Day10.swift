//
//  Day10.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

import Foundation

public func day10() {
    let content = content(file: "input10")
    let lines = content
        .split(separator: "\n", omittingEmptySubsequences: true)
        .map({ $0.map({ Int("\($0)")! }) })

    struct Pos: Hashable {
        let x: Int
        let y: Int
    }

    enum Direction: Int, CaseIterable {
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
    }

    func int(at: Pos) -> Int {
        guard at.x >= 0,
              at.y >= 0,
              at.y < lines.count,
              at.x < lines[at.y].count else {
            return -1
        }
        return lines[at.y][at.x]
    }

    func searchForTrail(from: Int, at: Pos) -> [Pos] {
        var endsFound: [Pos] = []
        for direction in Direction.allCases {
            let nextPos = Pos(x: at.x + direction.x, y: at.y + direction.y)
            let num = int(at: nextPos)
            if num == from + 1 {
                if num == 9 {
                    endsFound.append(nextPos)
                    continue
                } else {
                    endsFound.append(contentsOf: searchForTrail(from: num, at: nextPos))
                }
            }
        }
        return endsFound
    }

    var count1 = 0
    var count2 = 0
    for y in 0..<lines.count {
        for x in 0..<lines[y].count {
            if lines[y][x] == 0 {
                let ends = searchForTrail(from: 0, at: Pos(x: x, y: y))
                count1 += Set(ends).count
                count2 += ends.count
            }
        }
    }
    print(count1)
    print(count2)
}

