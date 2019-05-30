//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Foundation
import SPMUtility

protocol Command {
    /// Subcommand as it will be written on command-line
    var name: String { get }

    /// Overview for help
    var overview: String { get }

    func addOptions(to parser: ArgumentParser)
    func fillParseResult(_ parseResult: ArgumentParser.Result) throws
    func run() throws
}
