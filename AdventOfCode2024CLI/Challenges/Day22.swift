//
//  Day22.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

func day22() {
    var content = content(file: "input22")

//    content = """
//1
//2
//3
//2024
//"""

    var numbers = content.lines({ Int($0)! })

    let prune = 16777216

    var part1 = 0

    var bananasBySequence: [[Int]: Int] = [:]

    for i in 0..<numbers.count {
        var number = numbers[i]
        var lastPrice = Int("\(String(number).last!)")!
        var changes: [Int] = []
        var priceBySequence: [[Int]: Int] = [:]

        for _ in 0..<2000 {
            number = (number ^ (number * 64)) % prune
            number = (number ^ (number / 32)) % prune
            number = (number ^ (number * 2048)) % prune

            let price = Int("\(String(number).last!)")!
            let change = price - lastPrice
//            print(number, change)

            changes.append(change)
            if changes.count > 4 {
                changes.removeFirst()
            }
            if changes.count == 4,
               priceBySequence[changes] == nil {
                priceBySequence[changes] = price
//                print(changes, price)
            }
            lastPrice = price
        }
        part1 += number

        for (sequence, price) in priceBySequence {
            bananasBySequence[sequence] = (bananasBySequence[sequence] ?? 0) + price
        }
    }

    let (sequence, price) = bananasBySequence.max(by: { $0.value < $1.value })!

    let part2 = price

    print(part1)
    print(part2)

}
