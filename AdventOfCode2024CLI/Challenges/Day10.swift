//
//  Day10.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

import Foundation

func day10() {
    let grid = content(file: "input10")
        .grid({ Int("\($0)")! })

    func searchForTrailEnds(from: Int, at: Pos) -> [Pos] {
        var endsFound: [Pos] = []
        for direction in Direction.cardinals {
            let nextPos = at + direction
            guard let num = grid.at(nextPos) else { continue }
            if num == from + 1 {
                if num == 9 {
                    endsFound.append(nextPos)
                    continue
                } else {
                    endsFound.append(contentsOf: searchForTrailEnds(from: num, at: nextPos))
                }
            }
        }
        return endsFound
    }

    var count1 = 0
    var count2 = 0
    grid.loop { pos, element in
        guard element == 0 else { return }

        let ends = searchForTrailEnds(from: 0, at: pos)
        count1 += Set(ends).count
        count2 += ends.count
    }

    print(count1)
    print(count2)
}

