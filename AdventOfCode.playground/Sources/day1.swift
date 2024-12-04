//
//  day1.swift
//  
//
//  Created by Simon Salomons on 04/12/2024.
//

import Foundation

public func day1() {
    let fileURL = Bundle.main.url(forResource: "input1", withExtension: "txt")!
    let content = try! String(contentsOf: fileURL, encoding: .utf8)

    var list1: [Int] = []
    var list2: [Int] = []
    for line in content.components(separatedBy: "\n") {
        let components = line.components(separatedBy: "   ")
        guard components.count == 2 else { continue }

        list1.append(Int(components[0])!)
        list2.append(Int(components[1])!)
    }

    list1.sort()
    list2.sort()

    var sum = 0
    for (leftId, rightId) in zip(list1, list2) {
        sum += abs(leftId - rightId)
    }
    print(sum)

    // Part 2
    var sum2 = 0
    for leftId in list1 {
        let count = list2.count(where: { $0 == leftId })
        sum2 += leftId * count
    }
    print(sum2)
}
