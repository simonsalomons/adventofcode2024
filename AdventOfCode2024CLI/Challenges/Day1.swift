//
//  day1.swift
//  
//
//  Created by Simon Salomons on 04/12/2024.
//

import Foundation

func day1() {
    let lines = content(file: "input1").lines({ $0.numbers() })

    var list1: [Int] = []
    var list2: [Int] = []
    for line in lines {
        list1.append(line[0])
        list2.append(line[1])
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
