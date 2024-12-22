//
//  Day21.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

func day21() {
    let content = content(file: "input21")

    let codes = content.lines()

    let numberKeypadStartPos = Pos(x: 2, y: 3)
    let numberKeypad: [[Character]] = [
        ["7", "8", "9"],
        ["4", "5", "6"],
        ["1", "2", "3"],
        [".", "0", "A"]
    ]
    let directionalKeypad: [[Character]] = [
        [".", "^", "A"],
        ["<", "v", ">"]
    ]

    struct CacheKey: Hashable {
        let start: Pos
        let end: Pos
    }

    func shortestPaths(from start: Pos, to end: Pos, in keypad: [[Character]]) -> [[Pos]] {
        var queue: [Pos] = [start]
        var origins: [Pos: Set<Pos>] = [:]
        var scores: [Pos: Int] = [start: 0]

        while !queue.isEmpty {
            let pos = queue.removeFirst()
            let nextScore = scores[pos]! + 1

            guard pos != end else { break }

            for dir in Direction.cardinals {
                let nextPos = pos + dir

                guard keypad.contains(nextPos),
                      keypad.at(nextPos) != "." else {
                    continue
                }

                if let score = scores[nextPos] {
                    if score == nextScore {
                        var newOrigins = origins[nextPos] ?? []
                        newOrigins.insert(pos)
                        origins[nextPos] = newOrigins
                    } else if nextScore < score {
                        origins[nextPos] = [pos]
                    } else {
                        continue
                    }
                } else {
                    origins[nextPos] = [pos]
                }
                scores[nextPos] = nextScore

                queue.append(nextPos)
            }
        }

        func getPaths(from pos: Pos) -> [[Pos]] {
            if let origins = origins[pos] {
                return origins.flatMap { origin in
                    getPaths(from: origin).map({ $0 + [pos] })
                }
            }

            return [[pos]]
        }

        return getPaths(from: end)
    }

    func getDirections(forPath path: [Pos]) -> [Direction] {
        var directions: [Direction] = []
        for i in 1..<path.count {
            directions.append(
                Direction.cardinals.first(where: { path[i - 1] + $0 == path[i] })!
            )
        }
        return directions
    }

    var cache: [CacheKey: [String]] = [:]

    func shortestSequences(toTypeCode code: String, inKeypad keypad: [[Character]], withStartPos startPos: Pos) -> [String] {
        var pos = startPos
        var sequences: [String] = [""]

        var prevChar: Character?
        for character in code {
            if character == prevChar {
                sequences = sequences.map({ $0 + "A" })
            } else {
                let destination = keypad.first(where: { _, element in
                    element == character
                })!.0

                let cacheKey = CacheKey(start: pos, end: destination)
                let appendages: [String]
                if let cached = cache[cacheKey] {
                    appendages = cached
                } else {
                    let paths = shortestPaths(from: pos, to: destination, in: keypad)
                    let directions = paths.map({ getDirections(forPath: $0) })

                    appendages = directions.map { directions in
                        directions.map({ $0.debugCharacter }).joined() + "A"
                    }
                    cache[cacheKey] = appendages
                }

                sequences = sequences.flatMap { sequence in
                    appendages.map { appendage in
                        sequence + appendage
                    }
                }

                pos = destination
            }

            prevChar = character
        }

        return Dictionary(grouping: sequences, by: \.count).min(by: { $0.key < $1.key })?.value ?? []
    }


    func convert(_ sequences: [String], withKeypad keypad: [[Character]], startPos: Pos) -> [String] {
        var allSequences: [String] = []
        for sequence in sequences {
            allSequences += shortestSequences(toTypeCode: sequence, inKeypad: keypad, withStartPos: startPos)
        }
        return Dictionary(grouping: allSequences, by: \.count).min(by: { $0.key < $1.key })?.value ?? []
    }

    var directionalMovesCache: [[Character]: [String]] = [:]

    directionalKeypad.loop { pos1, char1 in
        guard char1 != "." else { return }

        directionalKeypad.loop { pos2, char2 in
            guard char2 != "." else { return }

            let cacheKey = [char1, char2]

            if char1 == char2 {
                directionalMovesCache[cacheKey] = ["A"]
            } else {
                let paths = shortestPaths(from: pos1, to: pos2, in: directionalKeypad)
                let sequences = paths.map({ getDirections(forPath: $0).map({ $0.debugCharacter }).joined() + "A" })
                directionalMovesCache[cacheKey] = sequences
            }
        }
    }

    struct LengthCacheKey: Hashable {
        let sequence: String
        let iterations: Int
    }

    var lengthCache: [LengthCacheKey: Int] = [:]

    func getLength(ofSequence sequence: String, iterations: Int) -> Int {
        guard iterations > 0 else { return sequence.count }

        let cacheKey = LengthCacheKey(sequence: sequence, iterations: iterations)
        if let cachedValue = lengthCache[cacheKey] {
            return cachedValue
        }

        var length = 0

        for (char1, char2) in zip("A" + sequence, sequence) {
            let subs = directionalMovesCache[[char1, char2]] ?? []

            var minLength: Int = .max

            for sub in subs {
                let length = getLength(ofSequence: sub, iterations: iterations - 1)

                minLength = min(minLength, length)
            }

            length += minLength
        }
        lengthCache[cacheKey] = length
        return length
    }

    func getComplexity(withDirectionalKeypadRobots dirbots: Int) -> Int {
        var sum = 0
        for code in codes {
            let sequences = convert([String(code)], withKeypad: numberKeypad, startPos: numberKeypadStartPos)

            var minimumLength: Int = .max

            for sequence in sequences {
                let length = getLength(ofSequence: sequence, iterations: dirbots)
                minimumLength = min(minimumLength, length)
            }

            var numString = code
            numString.removeLast()
            let numValue = Int(numString)!
            let complexity = minimumLength * numValue

            sum += complexity
        }
        return sum
    }

    let part1 = getComplexity(withDirectionalKeypadRobots: 2)
    print(part1)

    let part2 = getComplexity(withDirectionalKeypadRobots: 25)
    print(part2)

    // 2 directional robots: 203734
    // 25 directional robots: 246810588779586
}
