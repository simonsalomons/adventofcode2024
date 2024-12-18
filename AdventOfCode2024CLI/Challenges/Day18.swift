//
//  Day18.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

func day18() {
    let content = content(file: "input18")
    let gridSize = 71
    let initialByteCount = 1024

    enum Space {
        case empty
        case byte
    }

    var grid = Array(repeating: Array(repeating: Space.empty, count: gridSize), count: gridSize)
    let memory = content.lines({ $0.split(separator: ",").map({ Int($0)! }) }).map({ Pos(x: $0[0], y: $0[1]) })

    func printPath(_ path: [Pos]) {
        var charGrid = grid.map({ $0.map { space in
            switch space {
            case .byte: return "#"
            case .empty: return "."
            }
        } })
        for pos in path {
            charGrid.set("█", at: pos)
        }
        charGrid.print()
        print()
    }

    for i in 0..<initialByteCount {
        grid.set(.byte, at: memory[i])
    }

    let startPos = Pos(x: 0, y: 0)
    let endPos = Pos(x: gridSize - 1, y: gridSize - 1)

    struct Best {
        let origin: Pos?
        let score: Int
    }

    // Returns the number of steps in the shortest path. Nil if no path found
    func findPath() -> Int? {
        // dijkstra is overkill since the path has no weights. Regular bfs should be enough

        var queue: [(Pos, Int)] = [(startPos, 0)]
        var bests: [Pos: Best] = [startPos: Best(origin: nil, score: 0)]

        loop: while !queue.isEmpty {
            let (pos, score) = queue.removeFirst()

            let nextScore = score + 1

            for dir in Direction.cardinals {
                let nextPos = pos + dir

                guard grid.at(nextPos) != .byte,
                      grid.contains(pos) else {
                    continue
                }

                guard nextPos != endPos else {
                    bests[nextPos] = Best(origin: pos, score: nextScore)
                    break loop
                }

                if let best = bests[nextPos] {
                    if nextScore < best.score {
                        bests[nextPos] = Best(origin: pos, score: nextScore)
                    }
                } else {
                    bests[nextPos] = Best(origin: pos, score: nextScore)

                    if let index = queue.firstIndex(where: { $0.1 > nextScore }) {
                        queue.insert((nextPos, nextScore), at: index)
                    } else {
                        queue.append((nextPos, nextScore))
                    }
                }
            }
        }
        var path: [Pos] = []

        var reversePos: Pos? = endPos
        while let pos = reversePos {
            path.append(pos)
            reversePos = bests[pos]?.origin
        }

//        printPath(path)

        return bests[endPos]?.score
    }

    // Part 1
    if let score = findPath() {
        print(score)
    } else {
        print("No path found")
    }

    // Part 2

    // This would be faster with a binary search, but this only takes 10 seconds so...

    for i in initialByteCount..<memory.count {
        grid.set(.byte, at: memory[i])

        if findPath() == nil {
            let mem = memory[i]
            print("\(mem.x),\(mem.y)")
            return
        }
    }
}
