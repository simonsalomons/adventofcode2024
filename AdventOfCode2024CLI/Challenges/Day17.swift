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
    let program = components[1].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines)

    func run(_ program: String, register: Register) -> String {
        var reg = register
        let program = program.split(separator: ",").map({ Int($0)! })

        func comboOperand(for operand: Int) -> Int {
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
            case .adv:
                reg.a = Int(Double(reg.a) / pow(2.0, Double(comboOperand(for: operand))))

            case .bxl:
                reg.b = reg.b ^ operand

            case .bst:
                reg.b = comboOperand(for: operand) % 8

            case .jnz:
                guard reg.a != 0 else { break }

                pointer = operand
                continue

            case .bxc:
                reg.b = reg.b ^ reg.c

            case .out:
                output.append(comboOperand(for: operand) % 8)

            case .bdv:
                reg.b = Int(Double(reg.a) / pow(2.0, Double(comboOperand(for: operand))))

            case .cdv:
                reg.c = Int(Double(reg.a) / pow(2.0, Double(comboOperand(for: operand))))

            }

            pointer += 2
        }

        return output.map({ "\($0)" }).joined(separator: ",")
    }

    // Part 1
    print(run(program, register: reg))

    // Part 2
    print("I don't know")
}
