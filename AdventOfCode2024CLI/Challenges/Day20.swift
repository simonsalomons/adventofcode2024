//
//  Day20.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

func day20() {
    let content = content(file: "input20")
    let grid = content.grid()

    let startPos = grid.first(where: { pos, element in
        element == "S"
    })!.0
    let endPos = grid.first(where: { pos, element in
        element == "E"
    })!.0

    var path: [Pos] = [startPos]
    var prevPos: Pos?

    while path.last != endPos {
        for dir in Direction.cardinals {
            let nextPos = path.last! + dir

            guard nextPos != prevPos,
                  grid.at(nextPos) != "#" else {
                continue
            }

            prevPos = path.last!
            path.append(nextPos)
        }
    }

    /// Returns amount of shortcuts by timeSave
    func shortcuts(fromPathIndex index: Int, minTimeSave: Int, maxShortcutDistance: Int) -> [Int: Int] {
        let searchStartIndex = index + minTimeSave + 2
        let pathCount = path.count
        guard searchStartIndex < pathCount else { return [:] }

        let startPos = path[index]
        var shortcutsByTimeSave: [Int: Int] = [:]

        for i in searchStartIndex..<pathCount {
            // Check if reachable in 20 steps
            let xDiff = abs(startPos.x - path[i].x)
            let yDiff = abs(startPos.y - path[i].y)
            let shortcutDistance = xDiff + yDiff

            guard shortcutDistance <= maxShortcutDistance else { continue }

            let timeSave = i - index - shortcutDistance

            guard timeSave >= minTimeSave else { continue }

            shortcutsByTimeSave[timeSave] = (shortcutsByTimeSave[timeSave] ?? 0) + 1
        }

        return shortcutsByTimeSave
    }

    func shortcuts(minTimeSave: Int, maxShortcutDistance: Int) -> Int {
        var shortcutsByTimeSave: [Int: Int] = [:]

        for i in 0..<path.count {
            for (timeSave, shortcuts) in shortcuts(fromPathIndex: i, minTimeSave: minTimeSave, maxShortcutDistance: maxShortcutDistance) {
                shortcutsByTimeSave[timeSave] = (shortcutsByTimeSave[timeSave] ?? 0) + shortcuts
            }
        }

        return shortcutsByTimeSave.reduce(into: 0, { $0 += $1.value })
    }

    print("Part 1: ", shortcuts(minTimeSave: 100, maxShortcutDistance: 2))
    print("Part 2: ", shortcuts(minTimeSave: 100, maxShortcutDistance: 20))
}
