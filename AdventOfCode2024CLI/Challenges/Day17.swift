//
//  Day17.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

import _math
import Foundation

func day17() {
    let content = content(file: "input17")

    struct Register {
        var a: Int
        var b: Int
        var c: Int
    }

    enum Instruction: Int {
        case adv, bxl, bst, jnz, bxc, out, bdv, cdv
    }

    let components = content.split(separator: "\n\n")
    let values = components[0].lines({ Int($0.split(separator: ":")[1].trimmingCharacters(in: .whitespaces))! })
    let reg = Register(a: values[0], b: values[1], c: values[2])
    let program = components[1].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ",").map({ Int($0)! })

    func run(_ program: [Int], register: Register) -> String {
        var reg = register

        func combo(_ operand: Int) -> Int {
            switch operand {
            case 0...3:
                return operand
            case 4:
                return reg.a
            case 5:
                return reg.b
            case 6:
                return reg.c
            default:
                fatalError("Invalid combo operand \(operand)")
            }
        }

        var output: [Int] = []
        var pointer = 0
        while pointer < program.count {
            let instruction = Instruction(rawValue: program[pointer])!
            let operand = program[pointer + 1]

            switch instruction {
            case .adv: // 0
                reg.a = reg.a >> combo(operand)

            case .bxl: // 1
                reg.b = reg.b ^ operand

            case .bst: // 2
                reg.b = combo(operand) % 8

            case .jnz: // 3
                guard reg.a != 0 else { break }

                pointer = operand
                continue

            case .bxc: // 4
                reg.b = reg.b ^ reg.c

            case .out: // 5
                output.append(combo(operand) % 8)

            case .bdv: // 6
                reg.b = reg.a >> combo(operand)

            case .cdv: // 7
                reg.c = reg.a >> combo(operand)

            }

            pointer += 2
        }

        return output.map({ "\($0)" }).joined(separator: ",")
    }

    // Part 1
    print(run(program, register: reg))
    // 6,7,5,2,1,3,5,1,7

    // Part 2
    func findA(program: [Int], startAt answer: Int) -> Int? {
        if program.isEmpty { return answer }

        for i in 0..<8 {
            let a = answer << 3 | i
            var b = a % 8
            b = b ^ 3
            let c = a >> b
            b = b ^ 5
            b = b ^ c
            let output = b % 8
            if output == program.last && a != 0 {
                var program = program
                program.removeLast()
                if let sub = findA(program: program, startAt: a) {
                    return sub
                }
            }
        }
        return nil
    }

    if let part2 = findA(program: program, startAt: 0) {
        print(part2)
        // 216549846240877
    } else {
        print("No solution found")
    }
}
