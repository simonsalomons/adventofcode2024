//
//  Day16.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

func day16() {
    let content = content(file: "input16")

    enum Space {
        case start
        case end
        case wall
        case empty

        init (_ character: Character) {
            switch character {
            case "S": self = .start
            case "E": self = .end
            case "#": self = .wall
            default: self = .empty
            }
        }
    }

    let grid = content.grid({ Space($0) })

    let startDir = Direction.right
    let startPos = grid.first(where: { $1 == .start })!.0
    let endPos = grid.first(where: { $1 == .end })!.0

    struct Move {
        let pos: Pos
        let dir: Direction
        let score: Int
    }

    func printPath(_ path: [Pos]) {
        var charGrid = content.grid()
        for pos in path {
            charGrid.set("█", at: pos)
        }
        charGrid.print()
        print()
    }

    func score(for path: [Pos]) -> Int {
        var dir = startDir
        var score = 0

        for i in 1..<path.count {
            if path[i-1] + dir == path[i] {
                score += 1
            } else {
                score += 1_001
                for newDirection in Direction.cardinals {
                    if path[i-1] + newDirection == path[i] {
                        dir = newDirection
                        break
                    }
                }
            }
        }
        return score
    }

    func nextMoves(after move: Move) -> [Move] {
        let cost = move.score
        var moves: [Move] = []

        var rDir = move.dir
        rDir.rotate90()
        var nextPos = move.pos + rDir
        if grid.at(nextPos) != .wall {
            moves.append(Move(pos: move.pos, dir: rDir, score: cost + 1000))
        }

        var lDir = move.dir
        lDir.rotateMinus90()
        nextPos = move.pos + lDir
        if grid.at(nextPos) != .wall {
            moves.append(Move(pos: move.pos, dir: lDir, score: cost + 1000))
        }

        nextPos = move.pos + move.dir
        if grid.at(nextPos) != .wall {
            moves.append(Move(pos: nextPos, dir: move.dir, score: cost + 1))
        }

        return moves
    }

    // Dijkstra

    struct DirPos: Hashable {
        let pos: Pos
        let dir: Direction
    }
    struct Best {
        let score: Int
        var origins: Set<DirPos>
    }

    var bests: [DirPos: Best] = [:]

    var queue: [Move] = [Move(pos: startPos, dir: startDir, score: 0)]
    var ends: [DirPos] = []

    while !queue.isEmpty {
        let move = queue.removeFirst()
        let moveDirPos = DirPos(pos: move.pos, dir: move.dir)

        if move.pos == endPos {
            ends.append(moveDirPos)
            continue
        }

        let nextMoves = nextMoves(after: move)

        for nextMove in nextMoves {
            let nextMoveDirPos = DirPos(pos: nextMove.pos, dir: nextMove.dir)

            if nextMove.score < bests[nextMoveDirPos]?.score ?? .max {
                bests[nextMoveDirPos] = Best(score: nextMove.score, origins: [moveDirPos])

                if let index = queue.firstIndex(where: { $0.score > nextMove.score }) {
                    queue.insert(nextMove, at: index)
                } else {
                    queue.append(nextMove)
                }
            } else if var best = bests[nextMoveDirPos],
                      nextMove.score == best.score {
                best.origins.insert(moveDirPos)
                bests[nextMoveDirPos] = best
            }
        }
    }

    var positionsInShortestPaths: Set<DirPos> = []
    var backStack: [DirPos] = ends
    while !backStack.isEmpty {
        let dirPos = backStack.removeFirst()
        if !positionsInShortestPaths.contains(dirPos) {
            positionsInShortestPaths.insert(dirPos)

            let origins = bests[dirPos]?.origins ?? []
            backStack.append(contentsOf: origins)
        }
    }

    let uniquePositions = Array(Set(positionsInShortestPaths.map({ $0.pos })))
    printPath(uniquePositions)

    print(uniquePositions.count)
}
