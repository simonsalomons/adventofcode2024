//
//  Bool+Xor.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 24/12/2024.
//

extension Bool {
    static func ^ (left: Bool, right: Bool) -> Bool {
        return left != right
    }
}
