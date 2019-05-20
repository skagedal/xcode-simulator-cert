//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Foundation
import SQLite

extension Blob {
    var data: Data {
        return Data(bytes)
    }
}
