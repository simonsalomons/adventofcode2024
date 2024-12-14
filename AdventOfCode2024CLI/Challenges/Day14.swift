//
//  Day14.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

import Foundation

func day14() {
    struct Robot: Hashable {
        var pos: Pos
        let vel: Pos
    }

    var content = content(file: "input14")
    var gridSize = Pos(x: 101, y: 103)

//    content = """
//p=0,4 v=3,-3
//p=6,3 v=-1,-3
//p=10,3 v=-1,2
//p=2,0 v=2,-1
//p=0,0 v=1,3
//p=3,0 v=-2,-2
//p=7,6 v=-1,-3
//p=3,0 v=-1,-2
//p=9,3 v=2,3
//p=7,3 v=-1,2
//p=2,4 v=2,-3
//p=9,5 v=-3,-3
//"""
//    gridSize = Pos(x: 11, y: 7)





    var robots = content.lines { string in
        let components = string.split(separator: " ")
        let pos = components[0].components(separatedBy: "=")[1].components(separatedBy: ",").map({ Int($0)! })
        let vel = components[1].components(separatedBy: "=")[1].components(separatedBy: ",").map({ Int($0)! })
        return Robot(pos: Pos(x: pos[0], y: pos[1]), vel: Pos(x: vel[0], y: vel[1]))
    }
    let seconds = 100

    let mid = Pos(x: gridSize.x / 2,
                  y: gridSize.y / 2)

    // Returns the safetyIndex
    func move(seconds: Int) -> Int {
        var topLeftCount = 0
        var topRightCount = 0
        var bottomLeftCount = 0
        var bottomRightCount = 0

        for i in 0..<robots.count {
            var robot = robots[i]
            var x = (robot.pos.x + robot.vel.x * seconds) % gridSize.x
            var y = (robot.pos.y + robot.vel.y * seconds) % gridSize.y
            if x < 0 {
                x += gridSize.x
            }
            if y < 0 {
                y += gridSize.y
            }

            robot.pos.x = x
            robot.pos.y = y
            robots[i] = robot

            if x < mid.x {
                if y < mid.y {
                    topLeftCount += 1
                } else if y > mid.y {
                    bottomLeftCount += 1
                }
            } else if x > mid.x {
                if y < mid.y {
                    topRightCount += 1
                } else if y > mid.y {
                    bottomRightCount += 1
                }
            }
        }

        return topLeftCount * topRightCount * bottomLeftCount * bottomRightCount
    }

    func printGrid() {
        var grid = Array(repeating: Array(repeating: 0, count: gridSize.x), count: gridSize.y)

        for robot in robots {
            let val = grid.at(robot.pos) ?? 0
            grid.set(val + 1, at: robot.pos)
        }
        grid.print({ $0 == 0 ? "." : "\($0)" })
    }

    var minSafetyIndex = Int.max
    for i in 0..<Int.max {
        let safetyIndex = move(seconds: 1)

        if safetyIndex < minSafetyIndex {
            minSafetyIndex = safetyIndex
            print("Grid at \(i + 1) seconds")
            printGrid()
            print() // Put breakpoint here. Run and watch console until tree appears
        }
    }

//    let safetyIndex = move(seconds: 100)
//    print(safetyIndex)
}
