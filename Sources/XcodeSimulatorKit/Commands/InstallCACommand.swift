//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Foundation
import SPMUtility

class InstallCACommand: Command {
    private struct Options {
        var path: String? = nil
    }
    let name = "install-ca"
    let overview = "Install a Certificate Authority"

    private let binder = ArgumentBinder<Options>()
    private var options = Options()

    private let filteringBinder = ArgumentBinder<FilteringOptions>()
    private var filteringOptions = FilteringOptions()

    func addOptions(to parser: ArgumentParser) {
        binder.bind(positional: parser.add(
            positional: "path",
            kind: String.self,
            usage: "Path for the certificate to install"
        ), to: { options, path in
            options.path = path
        })

        filteringBinder.bind(to: &filteringOptions, parser: parser)
    }

    func fillParseResult(_ parseResult: ArgumentParser.Result) throws {
        try binder.fill(parseResult: parseResult, into: &options)
        try filteringBinder.fill(parseResult: parseResult, into: &filteringOptions)
    }

    func run() throws {
        let url = URL(fileURLWithPath: options.path!)
        let certificate = try Certificate.load(from: url)
        print(certificate)

        print(filteringOptions)
    }
}
