//
//  General.swift
//  AdventOfCode2024CLI
//
//  Created by Simon Salomons on 06/12/2024.
//

import Foundation

func content(file: String) -> String {
    let dir = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleUrl = URL(fileURLWithPath: "Inputs.bundle", relativeTo: dir)
    let bundle = Bundle(url: bundleUrl)
    let fileURL = bundle!.url(forResource: file, withExtension: "txt")!
    return try! String(contentsOf: fileURL, encoding: .utf8)
}
