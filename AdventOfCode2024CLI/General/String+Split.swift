//
//  Array+Split.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

extension String {

    func grid<T>(_ map: (Character) -> T = { $0 }) -> [[T]] {
        lines({ $0.map({ map($0) }) })
    }

    func lines<T>(_ map: (Substring) -> T = { $0 }) -> [T] {
        split(separator: "\n", omittingEmptySubsequences: true).map(map)
    }
}
