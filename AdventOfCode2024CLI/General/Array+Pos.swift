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

    func print<T>() where Element == [T] {
        for line in self {
            Swift.print(line.map({ "\($0)" }).joined())
        }
    }

    func loop<T>(_ closure: (_ pos: Pos, _ element: T) -> Void) where Element == [T] {
        for y in 0..<self.count {
            for x in 0..<self[y].count {
                closure(Pos(x: x, y: y), self[y][x])
            }
        }
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
