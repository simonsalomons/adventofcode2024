//
//  Day23.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

func day23() {
    let content = content(file: "input23")

    let connections = Set(content.lines({ $0.split(separator: "-").map({ String($0) }).sorted() }))

    // connections by computer
    var cbc: [String: Set<String>] = [:]

    for c in connections {
        cbc[c.first!] = (cbc[c.first!] ?? []).union([c.last!])
        cbc[c.last!] = (cbc[c.last!] ?? []).union([c.first!])
    }

    var lans: Set<Set<String>> = []

    computerLoop: for (computer, connections)  in cbc {
        for computer2 in connections {
            var lan: Set<String> = [computer, computer2]

            let otherComputers: Set<String> = connections.subtracting([computer2])
            for otherComputer in otherComputers {
                if cbc[otherComputer]?.isSuperset(of: lan) ?? false {
                    lan.insert(otherComputer)
                }
            }

            lans.insert(lan)
        }
    }

    // Part 1
    var trisWithT: Set<Set<String>> = []
    for lan in lans.filter({ $0.count >= 3 }) {
        for c1 in lan {
            for c2 in lan where c2 != c1 {
                for c3 in lan where c3 != c1 && c3 != c2 {
                    guard c1.hasPrefix("t") || c2.hasPrefix("t") || c3.hasPrefix("t") else { continue }

                    trisWithT.insert([c1, c2, c3])
                }
            }
        }
    }
    print(trisWithT.count)

    // Part 2
    let biggestLan = Dictionary(grouping: lans, by: { $0.count }).max(by: { $0.key < $1.key })!.value.first!
    print(biggestLan.sorted().joined(separator: ","))
}
