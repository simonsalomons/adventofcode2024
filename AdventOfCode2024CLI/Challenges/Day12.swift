//
//  Day12.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

func day12() {
    let grid = content(file: "input12").grid()

    var usedPositions: Set<Pos> = []

    func getAdjacentPlots(pos: Pos, char: Character) -> Set<Pos> {
        usedPositions.insert(pos)
        var plots: Set<Pos> = []
        plots.insert(pos)

        for dir in Direction.cardinals {
            let pos = pos + dir
            if !usedPositions.contains(pos) && grid.at(pos) == char {
                plots.formUnion(getAdjacentPlots(pos: pos, char: char))
            }
        }
        return plots
    }

    func getPerimeter(of pos: Pos) -> Int {
        guard let char = grid.at(pos) else { return 0 }

        var count = 0
        for dir in Direction.cardinals {
            if grid.at(pos + dir) != char {
                count += 1
            }
        }
        return count
    }

    func removeAdjecentPlots(of pos: Pos, from availablePlots: inout Set<Pos>) {
        availablePlots.remove(pos)

        for dir in Direction.cardinals {
            let pos = pos + dir
            if availablePlots.contains(pos) {
                availablePlots.remove(pos)
                removeAdjecentPlots(of: pos, from: &availablePlots)
            }
        }
    }

    func getSides(of plots: Set<Pos>) -> Int {
        guard let char = grid.at(plots.first!) else { return 0 }

        var sidesPerDir: [Direction: Set<Pos>] = [:]

        for plot in plots {
            for dir in Direction.cardinals {
                let pos = plot + dir
                if grid.at(pos) != char {
                    var sides = sidesPerDir[dir] ?? []
                    sides.insert(pos)
                    sidesPerDir[dir] = sides
                }
            }
        }
        var count = 0
        for (_, sides) in sidesPerDir {
            var availablePlots = sides
            var sideCount = 0
            while !availablePlots.isEmpty {
                removeAdjecentPlots(of: availablePlots.first!, from: &availablePlots)
                sideCount += 1
            }

            count += sideCount
        }
        return count
    }

    func calcPrice(startingPos: Pos) -> Int {
        guard let char = grid.at(startingPos) else { return 0 }

        let plots = getAdjacentPlots(pos: startingPos, char: char)
        let area = plots.count

        // Part 1
//        let perimeter = plots.reduce(into: 0) { $0 += getPerimeter(of: $1) }
//        print("\(char): \(area) * \(perimeter) = \(area * perimeter)")
//        return area * perimeter

        // Part 2
        let sides = getSides(of: plots)
        print("\(char): \(area) * \(sides) = \(area * sides)")
        return area * sides
    }

    var totalPrice = 0
    grid.loop { pos, element in
        if !usedPositions.contains(pos) {
            totalPrice += calcPrice(startingPos: pos)
        }
    }

    print(totalPrice)
}
