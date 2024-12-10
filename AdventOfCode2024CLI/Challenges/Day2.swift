//
//  day2.swift
//  
//
//  Created by Simon Salomons on 04/12/2024.
//

import Foundation

func day2() {
    let reports = content(file: "input2").lines { string in
        let components = string.components(separatedBy: " ").compactMap({ string -> Int? in
            guard let int = Int(string) else {
                return nil
            }
            return int
        })

        return components
    }

    func isReportSafe(_ report: [Int]) -> Bool {
        guard var lastLevel = report.first else { return false }

        var increasings: [Bool] = []
        for i in 1..<report.count {
            increasings.append(report[i] > lastLevel)
            let diff = abs(report[i] - lastLevel)
            guard diff >= 1 && diff <= 3 else {
                return false
            }

            lastLevel = report[i]
        }
        let grouped = Dictionary(grouping: increasings, by: { $0 })
        return grouped.count == 1
    }

    var safeReports = 0
    var unsafeReports: [[Int]] = []
    reportLoop: for report in reports {
        if isReportSafe(report) {
            safeReports += 1
        } else {
            unsafeReports.append(report)
        }
    }
    print(safeReports)

    // Part 2

    unsafeReportLoop: for unsafeReport in unsafeReports {
        for i in 0..<unsafeReport.count {
            var dampenedReport = unsafeReport
            dampenedReport.remove(at: i)

            if isReportSafe(dampenedReport) {
                safeReports += 1
                continue unsafeReportLoop
            }
        }
    }
    print(safeReports)
}
