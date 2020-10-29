//
//  SourceEditorCommand.swift
//  LocalizableStringsSorterExtension
//
//  Created by Guy Kogus on 06/06/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    private func isLocalizationLine(_ object: Any) -> Bool {
        guard let line = object as? String else { return false }
        return line.first == "\"" && line.suffix(2) == ";\n"
    }

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        let localizationLines = invocation
            .buffer
            .lines

        var lineNumbers = [Int]()
        var lines = [String]()
        lineNumbers.reserveCapacity(localizationLines.count)
        lines.reserveCapacity(localizationLines.count)
        for localizationLine in localizationLines.enumerated() where isLocalizationLine(localizationLine.element) {
            lineNumbers.append(localizationLine.offset)
            lines.append(localizationLine.element as! String)
        }
        lines.sort()

        for line in zip(lineNumbers, lines) {
            invocation.buffer.lines[line.0] = line.1
        }

        completionHandler(nil)
    }
}
