//
//  Day7.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 06/12/2024.
//

func day7() {
    struct Equation {
        let testValue: Int
        let operands: [Int]
    }

    let equations = content(file: "input7").lines { string in
        let components = string.split(separator: ":")
        return Equation(
            testValue: Int(components[0])!,
            operands: components[1]
                .split(separator: " ", omittingEmptySubsequences: true)
                .map({ Int($0)! })
        )
    }

    func solve(operands: [Int], operations: [(Int, Int) -> Int]) -> Set<Int> {
        var operands = operands
        let lhs = operands[0]
        let rhs = operands[1]
        operands.removeFirst(2)

        var outputs: Set<Int> = []
        for o in operations {
            let output = o(lhs, rhs)
            if operands.isEmpty {
                outputs.insert(output)
            } else {
                var operands = operands
                operands.insert(output, at: 0)
                outputs.formUnion(solve(operands: operands, operations: operations))
            }
        }
        return outputs
    }

    func calibrationResult(for operations: [(Int, Int) -> Int]) -> Int {
        var calibrationResult = 0
        for equation in equations {
            let outputs = solve(operands: equation.operands, operations: operations)

            if outputs.contains(equation.testValue) {
                calibrationResult += equation.testValue
            }
        }
        return calibrationResult
    }

    let part1 = calibrationResult(for: [
        { $0 + $1 },
        { $0 * $1 }
    ])
    print(part1)
    let part2 = calibrationResult(for: [
        { $0 + $1 },
        { $0 * $1 },
        { Int("\($0)\($1)")! }
    ])
    print(part2)
}
