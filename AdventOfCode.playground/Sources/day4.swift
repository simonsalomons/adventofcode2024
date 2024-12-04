//
//  day4.swift
//  
//
//  Created by Simon Salomons on 04/12/2024.
//

import Foundation

public func day4() {
    let fileURL = Bundle.main.url(forResource: "input4", withExtension: "txt")!
    var content = try! String(contentsOf: fileURL, encoding: .utf8)

    let lines = content
        .components(separatedBy: "\n")
        .compactMap({ line -> [Character]? in
            guard !line.isEmpty else { return nil }

            return Array(line)
        })

    enum Direction: CaseIterable {
        case right, left, up, down, upRight, upLeft, downRight, downLeft

        var offsetX: Int {
            switch self {
            case .right, .upRight, .downRight:
                return 1
            case .left, .upLeft, .downLeft:
                return -1
            case .up, .down:
                return 0
            }
        }
        var offsetY: Int {
            switch self {
            case .up, .upRight, .upLeft:
                return -1
            case .down, .downLeft, .downRight:
                return 1
            case .right, .left:
                return 0
            }
        }
    }

    // Returns the amount of xmasses found starting at the given point
    func findXmasses(x: Int, y: Int) -> Int {
        var count = 0
        for direction in Direction.allCases {
            if findXmas(x: x, y: y, offsetX: direction.offsetX, offsetY: direction.offsetY) {
                count += 1
            }
        }
        return count
    }

    // Returns true if xmax is found at the given point with the given offsets
    func findXmas(x: Int, y: Int, offsetX: Int, offsetY: Int) -> Bool {
        guard findLetter("M", x: x + offsetX, y: y + offsetY) else { return false }
        guard findLetter("A", x: x + offsetX * 2, y: y + offsetY * 2) else { return false }
        guard findLetter("S", x: x + offsetX * 3, y: y + offsetY * 3) else { return false }
        return true
    }

    // Returns true if the location is valid and the letter is found
    func findLetter(_ letter: Character, x: Int, y: Int) -> Bool {
        guard x >= 0, y >= 0 else { return false }
        guard y < lines.count else { return false}
        guard x < lines[y].count else { return false }

        return lines[y][x] == letter
    }

    var count = 0
    for y in 0..<lines.count {
        for x in 0..<lines[y].count {
            if lines[y][x] == "X" {
                count += findXmasses(x: x, y: y)
            }
        }
    }

    print(count)

    // Part 2

    func findMasX(x: Int, y: Int) -> Bool {
        findMasé(x: x, y: y) && findMasè(x: x, y: y)
    }

    func findMasè(x: Int, y: Int) -> Bool {
        (findLetter("M", x: x - 1, y: y - 1) && findLetter("S", x: x + 1, y: y + 1))
        || (findLetter("S", x: x - 1, y: y - 1) && findLetter("M", x: x + 1, y: y + 1))
    }

    func findMasé(x: Int, y: Int) -> Bool {
        (findLetter("M", x: x - 1, y: y + 1) && findLetter("S", x: x + 1, y: y - 1))
        || (findLetter("S", x: x - 1, y: y + 1) && findLetter("M", x: x + 1, y: y - 1))
    }

    var count2 = 0
    for y in 0..<lines.count {
        for x in 0..<lines[y].count {
            if lines[y][x] == "A" && findMasX(x: x, y: y) {
                count2 += 1
            }
        }
    }
    print(count2)
}
