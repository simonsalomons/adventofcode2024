//
//  main.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 06/12/2024.
//

import Foundation

let startTime = DispatchTime.now()

day21()

let endTime = DispatchTime.now()
let elapsed = Duration.nanoseconds(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds)
print()
print("⏱️ \(elapsed)")

