//
//  day3.swift
//  
//
//  Created by Simon Salomons on 04/12/2024.
//

import Foundation

public func day3() {
    var content = content(file: "input3")

    // Part 2 (comment out for part 1)
    let dos = content.components(separatedBy: "do()").compactMap({ $0.components(separatedBy: "don't()").first })
    content = dos.joined(separator: "")

    // Part 1
    let mults = content
        .components(separatedBy: "mul(")
        .compactMap({ $0.components(separatedBy: ")").first })
        .compactMap({ string -> Int? in
            let components = string.components(separatedBy: ",")
            guard components.count == 2 else { return nil }
            var numbers: [Int] = []
            for component in components {
                guard let number = Int(component) else {
                    // print("\(component) is not a number")
                    return nil
                }
                guard number >= 0 && number < 1000 else {
                    // print("\(number) is not valid")
                    return nil
                }
                numbers.append(number)
            }
            return numbers[0] * numbers[1]
        })
    let sum = mults.reduce(0, +)
    print(sum)
}
