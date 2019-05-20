//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//
// swiftlint:disable line_length

import Foundation

extension Data {
    func dumpAsSwift(_ name: String = "data") {
        if count > 48 {
            print(#"""
                let \#(name) = Data(base64Encoded: """
                    \#(base64EncodedString(options: .lineLength64Characters).replacingOccurrences(of: "\n", with: "\n    "))
                """, options: .ignoreUnknownCharacters)
                """#)
        } else {
            print(#"let \#(name) = Data(base64Encoded: "\#(base64EncodedString())")"#)
        }
    }
}
