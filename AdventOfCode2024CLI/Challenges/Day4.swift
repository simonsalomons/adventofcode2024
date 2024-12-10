//
//  day4.swift
//  
//
//  Created by Simon Salomons on 04/12/2024.
//

import Foundation

public func day4() {
    let grid = content(file: "input4").grid()

    // Returns the amount of xmasses found starting at the given point
    func findXmasses(pos: Pos) -> Int {
        var count = 0
        for direction in Direction.all {
            if findXmas(pos: pos, offset: direction.offset) {
                count += 1
            }
        }
        return count
    }

    // Returns true if xmax is found at the given point with the given offsets
    func findXmas(pos: Pos, offset: Pos) -> Bool {
        guard grid.at(pos + offset) == "M" else { return false }
        guard grid.at(pos + offset * 2) == "A" else { return false }
        guard grid.at(pos + offset * 3) == "S" else { return false }

        return true
    }

    var count = 0
    grid.loop { pos, element in
        if element == "X" {
            count += findXmasses(pos: pos)
        }
    }

    print(count)

    // Part 2

    func findMasX(pos: Pos) -> Bool {
        findMasé(pos: pos) && findMasè(pos: pos)
    }

    func findMasè(pos: Pos) -> Bool {
        let pos1 = pos - Pos(x: 1, y: 1)
        let pos2 = pos + Pos(x: 1, y: 1)

        return (grid.at(pos1) == "M" && grid.at(pos2) == "S")
        || (grid.at(pos1) == "S" && grid.at(pos2) == "M")
    }

    func findMasé(pos: Pos) -> Bool {
        let pos1 = pos + Pos(x: -1, y: 1)
        let pos2 = pos + Pos(x: 1, y: -1)

        return (grid.at(pos1) == "M" && grid.at(pos2) == "S")
        || (grid.at(pos1) == "S" && grid.at(pos2) == "M")
    }

    var count2 = 0
    grid.loop { pos, element in
        if element == "A" && findMasX(pos: pos) {
            count2 += 1
        }
    }
    print(count2)
}
