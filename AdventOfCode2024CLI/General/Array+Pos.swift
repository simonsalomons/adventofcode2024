//
//  Array+Pos.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

extension Array {

    func at<T>(_ pos: Pos) -> T? where Element == [T] {
        guard contains(pos) else { return nil }

        return self[pos.y][pos.x]
    }

    func contains<T>(_ pos: Pos) -> Bool where Element == [T] {
        guard pos.x >= 0,
              pos.y >= 0,
              pos.y < self.count,
              pos.x < self[pos.y].count else {
            return false
        }

        return true
    }

    mutating func set<T>(_ value: T, at pos: Pos) where Element == [T] {
        self[pos.y][pos.x] = value
    }

    func print<T>(_ map: (T) -> String = { "\($0)" }) where Element == [T] {
        for line in self {
            Swift.print(line.map(map).joined())
        }
    }

    func loop<T>(_ closure: (_ pos: Pos, _ element: T) -> Void) where Element == [T] {
        for y in 0..<self.count {
            for x in 0..<self[y].count {
                closure(Pos(x: x, y: y), self[y][x])
            }
        }
    }

    mutating func swap<T>(pos pos1: Pos, andPos pos2: Pos) where Element == [T] {
        let temp = self.at(pos1)!
        self.set(self.at(pos2)!, at: pos1)
        self.set(temp, at: pos2)
    }

    @discardableResult func first<T>(where closure: (_ pos: Pos, _ element: T) -> Bool) -> (Pos, T)? where Element == [T] {
        for y in 0..<self.count {
            for x in 0..<self[y].count {
                let pos = Pos(x: x, y: y)
                let element = self[y][x]
                if closure(pos, element) {
                    return (pos, element)
                }
            }
        }

        return nil
    }
}
