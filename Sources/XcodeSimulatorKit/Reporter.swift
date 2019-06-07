//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Foundation

protocol Reporter {
    func info(_ string: String)
}

class DefaultReporter: Reporter {
    private let verbosity: Verbosity

    init(verbosity: Verbosity) {
        self.verbosity = verbosity
    }

    func info(_ string: String) {
        guard verbosity == .loud else { return }
        print("INFO: ", terminator: "")
        print(string)
    }
}
