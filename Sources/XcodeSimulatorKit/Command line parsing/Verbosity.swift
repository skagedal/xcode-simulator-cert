//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Foundation
import SPMUtility

enum Verbosity: String, StringEnumArgument {
    case silent
    case normal
    case loud

    public static var completion: ShellCompletion = .none
}
