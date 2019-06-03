//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Foundation

protocol Reporter {

}

class DefaultReporter: Reporter {
    private let verbosity: Verbosity

    init(verbosity: Verbosity) {
        self.verbosity = verbosity
    }
}
