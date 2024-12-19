//
//  Day19.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

func day19() {
    let content = content(file: "input19")

    let components = content.split(separator: "\n\n", omittingEmptySubsequences: true)

    let towels = components[0].split(separator: ", ", omittingEmptySubsequences: true).sorted()
    let towelsByFirstLetter = Dictionary(grouping: towels, by: { $0.first! })
    let designs = components[1].lines()

    var cache: [Substring: Int] = [:]
    func possibleArrangements(_ design: Substring) -> Int {
        if let count = cache[design] {
            return count
        }

        var count: Int = 0
        for towel in towelsByFirstLetter[design.first!] ?? [] {
            if design.hasPrefix(towel) {
                let remainingDesign = design[design.index(design.startIndex, offsetBy: towel.count)...]
                if remainingDesign.isEmpty {
                    count += 1
                } else {
                    count += possibleArrangements(remainingDesign)
                }
            }
        }
        cache[design] = count
        return count
    }

    var part1 = 0
    var part2 = 0
    for design in designs {
        let arrangements = possibleArrangements(design)
        if arrangements > 0 {
            part1 += 1
        }
        part2 += arrangements
    }
    print(part1)
    print(part2)
}
