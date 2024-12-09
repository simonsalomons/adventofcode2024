//
//  Day8.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 08/12/2024.
//

import Foundation

public func day8() {
    let content = content(file: "input8")

    struct Pos: Hashable {
        let x: Int
        let y: Int
    }

    var placesPerNode: [String: [Pos]] = [:]

    var lines = content
        .split(separator: "\n", omittingEmptySubsequences: true)
        .map({ $0.map({ "\($0)" }) })

    for y in 0..<lines.count {
        for x in 0..<lines[y].count where lines[y][x] != "." {
            var places = placesPerNode[lines[y][x]] ?? []
            places.append(Pos(x: x, y: y))
            placesPerNode[lines[y][x]] = places
        }
    }

    var antinodes: Set<Pos> = []

    // Returns true if inside bounds
    @discardableResult func addAntinode(_ pos: Pos) -> Bool {
        guard pos.x >= 0,
              pos.y >= 0,
              pos.y < lines.count,
              pos.x < lines[pos.y].count else {
            return false
        }
        antinodes.insert(pos)
        return true
    }

    // Part 1

    for (_, nodes) in placesPerNode {
        guard nodes.count > 1 else { continue }

        // Only for part 2
        for node in nodes {
            addAntinode(node)
        }

        for i in 0..<nodes.count {
            for j in (i + 1)..<nodes.count {
                let diff1 = Pos(x: nodes[j].x - nodes[i].x,
                                y: nodes[j].y - nodes[i].y)
                let diff2 = Pos(x: nodes[i].x - nodes[j].x,
                                y: nodes[i].y - nodes[j].y)


                // Part 1
//                addAntinode(Pos(x: nodes[j].x + diff1.x,
//                                y: nodes[j].y + diff1.y))
//                addAntinode(Pos(x: nodes[i].x + diff2.x,
//                                y: nodes[i].y + diff2.y))

                // Part 2
                var insideBounds = true
                var startPos = nodes[j]
                repeat {
                    let pos = Pos(x: startPos.x + diff1.x,
                                  y: startPos.y + diff1.y)
                    insideBounds = addAntinode(pos)
                    startPos = pos
                } while insideBounds

                insideBounds = true
                startPos = nodes[i]
                repeat {
                    let pos = Pos(x: startPos.x + diff2.x,
                                  y: startPos.y + diff2.y)
                    insideBounds = addAntinode(pos)
                    startPos = pos
                } while insideBounds
            }
        }
    }

    for antinode in antinodes {
        lines[antinode.y][antinode.x] = "#"
    }
    for line in lines {
        print(line.joined(separator: ""))
    }
    print()
    print(antinodes.count)
}