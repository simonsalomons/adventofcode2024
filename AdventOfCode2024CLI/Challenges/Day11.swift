//
//  Day11.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

func day11() {
    let input = content(file: "input11").split(separator: " ", omittingEmptySubsequences: true)
        .map({ Int($0.trimmingCharacters(in: .whitespacesAndNewlines))! })

    struct Stone: Hashable {
        let value: Int
        var count: Int
    }

    var stones = Set(input.map({ Stone(value: $0, count: 1) }))

    func insert(value: Int, count: Int, in stones: inout Set<Stone>) {
        if let index = stones.firstIndex(where: { $0.value == value }) {
            var stone = stones.remove(at: index)
            stone.count += count
            stones.insert(stone)
        } else {
            stones.insert(Stone(value: value, count: count))
        }
    }

    for count in 0..<75 {
        var newStones: Set<Stone> = []
        while !stones.isEmpty {
            let stone = stones.removeFirst()

            if stone.value == 0 {
                insert(value: 1, count: stone.count, in: &newStones)
            } else if String(stone.value).count % 2 == 0 {
                let str = String(stone.value)
                let count = str.count
                let sub1 = str[..<str.index(str.startIndex, offsetBy: count / 2)]
                let sub2 = str[str.index(str.startIndex, offsetBy: count / 2)...]
                insert(value: Int(sub1)!, count: stone.count, in: &newStones)
                insert(value: Int(sub2)!, count: stone.count, in: &newStones)
            } else {
                insert(value: stone.value * 2024, count: stone.count, in: &newStones)
            }
        }

        stones = newStones
        let sum = stones.reduce(into: 0) { total, stone in
            total += stone.count
        }
        print("\(count + 1):", sum)
    }
}
