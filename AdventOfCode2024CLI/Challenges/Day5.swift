//
//  day5.swift
//  
//
//  Created by Simon Salomons on 05/12/2024.
//

import Foundation

func day5() {
    let content = content(file: "input5")

    struct Rule: Hashable, CustomDebugStringConvertible {
        let first: Int
        let second: Int

        var debugDescription: String {
            "[\(first), \(second)]"
        }
    }

    let contents = content.components(separatedBy: "\n\n")
    let rules = Set(contents[0].lines { string in
        let components = string.components(separatedBy: "|").compactMap({ Int($0) })
        return Rule(first: components[0], second: components[1])
    })
    let updates = contents[1].lines({ string in
        string.components(separatedBy: ",").compactMap({ Int($0) })
    })

    func isUpdateValid(_ update: [Int], withRules rules: Set<Rule>) -> Bool {
        var forbiddenPages: Set<Int> = []
        for page in update {
            guard !forbiddenPages.contains(page) else { return false }

            for ruleEndingWithPage in rules.filter({ $0.second == page }) {
                forbiddenPages.insert(ruleEndingWithPage.first)
            }
        }
        return true
    }

    var validUpdates: Set<[Int]> = []
    var invalidUpdates: Set<[Int]> = []
    for update in updates {
        if isUpdateValid(update, withRules: rules) {
            validUpdates.insert(update)
        } else {
            invalidUpdates.insert(update)
        }
    }

    let sumOfCenters = validUpdates.reduce(into: 0, { $0 += $1[$1.count / 2] })

    print(sumOfCenters)

    // Part 2

    var fixedUpdates: Set<[Int]> = []
    for update in invalidUpdates {
        var impactedRules: Set<Rule> = []
        for rule in rules {
            if (update.contains(rule.first) && update.contains(rule.second)) {
                impactedRules.insert(rule)
            }
        }

        var fixedUpdate = update
        while !isUpdateValid(fixedUpdate, withRules: impactedRules) {
            rulesLoop: for rule in impactedRules {
                guard let firstPageIndex = fixedUpdate.firstIndex(of: rule.first),
                      let secondPageIndex = fixedUpdate.firstIndex(of: rule.second) else {
                    continue
                }
                if secondPageIndex < firstPageIndex {
                    fixedUpdate.swapAt(firstPageIndex, secondPageIndex)
                    break rulesLoop
                }
            }
        }
        fixedUpdates.insert(fixedUpdate)
    }

    let sumOfCenters2 = fixedUpdates.reduce(into: 0, { $0 += $1[$1.count / 2] })

    print(sumOfCenters2)
}
