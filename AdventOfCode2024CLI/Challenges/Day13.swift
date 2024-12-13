//
//  Day13.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 10/12/2024.
//

func day13() {
    let content = content(file: "input13")

    struct Machine: Hashable {
        let a: Pos
        let b: Pos
        var prize: Pos
    }

    var machines = content.split(separator: "\n\n", omittingEmptySubsequences: true).map { block in
        let components = block.split(separator: "\n", omittingEmptySubsequences: true)
        let aComp = components[0].split(separator: ":")[1].components(separatedBy: ",").map({ $0.components(separatedBy: "+") })
        let bComp = components[1].split(separator: ":")[1].components(separatedBy: ",").map({ $0.components(separatedBy: "+") })
        let pComp = components[2].split(separator: ":")[1].components(separatedBy: ",").map({ $0.components(separatedBy: "=") })
        return Machine(a: Pos(x: Int(aComp[0][1])!, y: Int(aComp[1][1])!),
                       b: Pos(x: Int(bComp[0][1])!, y: Int(bComp[1][1])!),
                       prize: Pos(x: Int(pComp[0][1])!, y: Int(pComp[1][1])!))
    }

    // For Part 2
    machines = machines.map({ machine in
        var machine = machine
        machine.prize.x += 10_000_000_000_000
        machine.prize.y += 10_000_000_000_000
        return machine
    })



    var prizes = 0
    var tokens = 0

    for machine in machines {
        let A = machine.a
        let B = machine.b
        let P = machine.prize

/*
 Solve these:
 A.x * a    +    B.x * b    =    P.x
 A.y * a    +    B.y * b    =    P.y

 // Make them equal to 0
 A.x * a    +    B.x * b    -    P.x    =    0
 A.y * a    +    B.y * b    -    P.y    =    0



 // Calculate a

 // Make the b segment equal (but opposite sign) by multiplying the equations by what's missing
 A.x * B.y * a    +    B.x * B.y * b    -    P.x * B.y    =    0          (Multiply by B.y)
 A.y * -B.x * a    +    -B.x * B.y * b    -    P.y * -B.x    =    0          (Multiply by -B.x)
 // Rewrite second
 -A.y * B.x * a    -    B.x * B.y * b    +    P.y * B.x    =    0

 // Add both equations together so the b segment disappears
 A.x * B.y * a    +    -A.y * B.x * a    -    P.x * B.y    +    P.y * B.x    =    0
 // Rewrite
 a * A.x * B.y    -    a * A.y * B.x    -    P.x * B.y    +    P.y * B.x    =    0
 // Move segments without a to the right
 a * A.x * B.y    -    a * A.y * B.x    =    P.x * B.y    -    P.y * B.x
 // Group a
 a * (A.x * B.y    -    A.y * B.x)    =    P.x * B.y    -    P.y * B.x
 // Divide so a is alone
 a    =    (P.x * B.y    -    P.y * B.x)    /    (A.x * B.y    -    A.y * B.x)





 // Calculate b

 // Make the a segment equal (but opposite sign) by multiplying the equations by what's missing
 A.x * A.y * a    +    A.y * B.x * b    -    A.y * P.x    =    0          (Multiply by A.y)
 -A.x * A.y * a    -    A.x * B.y * b     +    P.y * A.x    =    0          (Multiply by -A.x)

 // Add both equations together so the a segment disappears
 A.y * B.x * b    -    A.x * B.y * b    -    A.y * P.x    +    P.y * A.x    =    0
 // Move segments without b to the right
 A.y * B.x * b    -    A.x * B.y * b    =    A.y * P.x    -    P.y * A.x
 // Group b
 b * (A.y * B.x    -    A.x * B.y)    =    A.y * P.x    -    P.y * A.x
 // Divide so b is alone
 b    =    (A.y * P.x    -    P.y * A.x)    /    (A.y * B.x    -    A.x * B.y)

 */
        let a = (P.x * B.y - P.y * B.x) / (A.x * B.y - A.y * B.x)
        let b = (A.y * P.x - P.y * A.x) / (A.y * B.x - A.x * B.y)
        let x = A.x * a + B.x * b
        let y = A.y * a + B.y * b

        // Check if x and y equals the prize. If it doesn't, the ideal solution is a decimal and therefor not a winner
        if x == P.x && y == P.y {
            prizes += 1
            tokens += 3 * a + b
        }
    }

    print("\(prizes) prizes")
    print("\(tokens) tokens")
}
