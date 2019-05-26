//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Foundation
import SPMUtility

struct InstallCACommand: Command {
    let name = "install-ca"
    let overview = "Install a Certificate Authority"

    private let binder = ArgumentBinder<InstallCACommand>()

    func addOptions(to parser: ArgumentParser) {
        binder.bind(positional: parser.add(
            positional: "path",
            kind: String.self
        ), to: { command, path in
            print("Chosen path: \(path)")
        })
    }

    mutating func fillParseResult(_ parseResult: ArgumentParser.Result) throws {
        try binder.fill(parseResult: parseResult, into: &self)
    }

    func run() throws {
        print("Running!")
    }
}
