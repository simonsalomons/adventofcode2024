//
//  Day24.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

func day24() {
    var content = content(file: "input24")

//    content = """
//x00: 1
//x01: 0
//x02: 1
//x03: 1
//x04: 0
//y00: 1
//y01: 1
//y02: 1
//y03: 1
//y04: 1
//
//ntg XOR fgs -> mjb
//y02 OR x01 -> tnw
//kwq OR kpj -> z05
//x00 OR x03 -> fst
//tgd XOR rvg -> z01
//vdt OR tnw -> bfw
//bfw AND frj -> z10
//ffh OR nrd -> bqk
//y00 AND y03 -> djm
//y03 OR y00 -> psh
//bqk OR frj -> z08
//tnw OR fst -> frj
//gnj AND tgd -> z11
//bfw XOR mjb -> z00
//x03 OR x00 -> vdt
//gnj AND wpb -> z02
//x04 AND y00 -> kjc
//djm OR pbm -> qhw
//nrd AND vdt -> hwm
//kjc AND fst -> rvg
//y04 OR y02 -> fgs
//y01 AND x02 -> pbm
//ntg OR kjc -> kwq
//psh XOR fgs -> tgd
//qhw XOR tgd -> z09
//pbm OR djm -> kpj
//x03 XOR y03 -> ffh
//x00 XOR y04 -> ntg
//bfw OR bqk -> z06
//nrd XOR fgs -> wpb
//frj XOR qhw -> z04
//bqk OR frj -> z07
//y03 OR x01 -> nrd
//hwm AND bqk -> z03
//tgd XOR rvg -> z12
//tnw OR pbm -> gnj
//"""

    content = """
x00: 0
x01: 1
x02: 0
x03: 1
x04: 0
x05: 1
y00: 0
y01: 0
y02: 1
y03: 1
y04: 0
y05: 1

x00 AND y00 -> z05
x01 AND y01 -> z02
x02 AND y02 -> z01
x03 AND y03 -> z03
x04 AND y04 -> z04
x05 AND y05 -> z00
"""

//    content = """
//x00: 1
//x01: 1
//x02: 1
//y00: 0
//y01: 1
//y02: 0
//
//x00 AND y00 -> z00
//x01 XOR y01 -> z01
//x02 OR y02 -> z02
//"""

    enum Operator: String {
        case and = "AND"
        case or = "OR"
        case xor = "XOR"
    }

    struct Operation {
        let lhs: String
        let `operator`: Operator
        let rhs: String
    }

    let components = content.split(separator: "\n\n")

    var gateValues: [String: Bool] = [:]
    var gates: [String: Operation] = [:]

    components[0].lines().forEach { string in
        let c = string.split(separator: ": ")
        gateValues[String(c[0])] = c[1] == "1" ? true : false
    }

    components[1].lines().forEach { string in
        let c = string.split(separator: " -> ")
        let o = c[0].split(separator: " ")
        gates[String(c[1])] = Operation(lhs: String(o[0]),
                                        operator: Operator(rawValue: String(o[1]))!,
                                        rhs: String(o[2]))
    }

    func getValue(of gate: String) -> Bool {
        if let value = gateValues[gate] {
            return value
        } else {
            let operation = gates[gate]!
            let lhs = getValue(of: operation.lhs)
            let rhs = getValue(of: operation.rhs)

            let value =
            switch operation.operator {
            case .and:
                lhs && rhs
            case .or:
                lhs || rhs
            case .xor:
                lhs ^ rhs
            }
            gateValues[gate] = value
            return value
        }
    }

    let endGates = gates.keys.filter({ $0.hasPrefix("z") }).sorted()

    let xGates = gateValues.keys.filter({ $0.hasPrefix("x") }).sorted()
    let yGates = gateValues.keys.filter({ $0.hasPrefix("y") }).sorted()
    let xString = xGates.map({ gateValues[$0]! ? "1" : "0" }).reversed().joined()
    let yString = yGates.map({ gateValues[$0]! ? "1" : "0" }).reversed().joined()
    let x = Int(xString, radix: 2)!
    let y = Int(yString, radix: 2)!
    let expected = x & y
    var expectedString = String(expected, radix: 2)//.padding(toLength: endGates.count, withPad: "0", startingAt: 0)
    expectedString = String(repeating: "0", count: endGates.count - expectedString.count) + expectedString

    var endValues: [Bool] = []
    for gate in endGates {
        endValues.append(getValue(of: gate))
    }

    let string = endValues.reversed().map({ $0 ? "1" : "0" }).joined()
    let part1 = Int(string, radix: 2)!

    print("Expected:", expectedString)
    print("Received:", string)
    print(part1)
}
