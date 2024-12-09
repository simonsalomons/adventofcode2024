//
//  Day9.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 09/12/2024.
//

import Foundation

public func day9() {
    let content = content(file: "input9").trimmingCharacters(in: .whitespacesAndNewlines)

    enum Block {
        case file(id: Int, size: Int)
        case space(size: Int)

        var isFile: Bool {
            switch self {
            case .file:
                return true
            case .space:
                return false
            }
        }
    }

    var blocks: [Block] = []

    var count = 0
    for character in content {
        let size = Int("\(character)")!
        if count % 2 == 0 {
            blocks.append(.file(id: count / 2, size: size))
        } else {
            blocks.append(.space(size: size))
        }

        count += 1
    }

    var blocks1 = blocks
    var disk: [Int] = []
    var lastFileBlockId: Int = 0
    var lastFileBlockSize: Int = 0

    for i in 0..<blocks1.count {
        guard i < blocks1.count else { break }

        switch blocks1[i] {
        case let .file(id, size):
            disk += Array(repeating: id, count: size)
        case let .space(size):
            for _ in 0..<size {
                while lastFileBlockSize == 0 && !blocks1.isEmpty {
                    switch blocks1.removeLast() {
                    case let .file(id, size):
                        lastFileBlockSize = size
                        lastFileBlockId = id
                    case .space:
                        break
                    }
                }

                disk.append(lastFileBlockId)
                lastFileBlockSize -= 1
            }
        }
    }
    for _ in 0..<lastFileBlockSize {
        disk.append(lastFileBlockId)
    }

    var checksum = 0
    for (index, block) in disk.enumerated() {
        checksum += index * block
    }
    print(checksum)

    // Part 2

    for i in (0..<blocks.count).reversed() {
        var doItAgain = false
        repeat {
            doItAgain = false

            switch blocks[i] {
            case let .file(fileId, fileSize):
                freeSpaceFinder: for j in 0..<i {
                    switch blocks[j] {
                    case let .space(size):
                        if size >= fileSize {
                            blocks[j] = .file(id: fileId, size: fileSize)
                            blocks[i] = .space(size: fileSize)
                            if size > fileSize {
                                blocks.insert(.space(size: size - fileSize), at: j + 1)
                                doItAgain = true
                            }

//                            print(blocks.map { block in
//                                switch block {
//                                case let .file(id, size):
//                                    return Array(repeating: "\(id)", count: size).joined()
//                                case let .space(size):
//                                    return Array(repeating: ".", count: size).joined()
//                                }
//                            }.joined())

                            break freeSpaceFinder
                        }
                    case .file:
                        break
                    }
                }
            case .space:
                break
            }

        } while doItAgain
    }

    var checksum2 = 0
    var count2 = 0
    for block in blocks {
        switch block {
        case let .file(id, size):
            for _ in 0..<size {
                checksum2 += id * count2
                count2 += 1
            }
        case let .space(size):
            count2 += size
        }
    }
    print(checksum2)
}
