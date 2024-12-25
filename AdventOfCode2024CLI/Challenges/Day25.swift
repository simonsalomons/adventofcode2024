//
//  Day25.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

func day25() {
    let content = content(file: "input25")

    var locks: [[Int]] = []
    var keys: [[Int]] = []
    content.split(separator: "\n\n").forEach { string in
        let grid = string.grid()
        if string.first == "#" {
            locks.append((0..<5).map({ x in
                (0..<7).first(where: { grid[$0][x] == "." })! - 1
            }))
        } else {
            keys.append((0..<5).map({ x in
                6 - (0..<7).first(where: { grid[$0][x] == "#" })!
            }))
        }
    }

    var sum = 0
    for lock in locks {
        keyloop: for key in keys {
            for (l, k) in zip(lock, key) {
                if l + k > 5 {
                    continue keyloop
                }
            }
            sum += 1
        }
    }

    print(sum)
}
