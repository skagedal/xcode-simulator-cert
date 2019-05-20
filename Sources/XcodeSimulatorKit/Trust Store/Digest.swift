//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import CommonCrypto
import Foundation

enum Digest {
    static func sha1(_ data: Data) -> Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes { input in
            _ = CC_SHA1(input.baseAddress, CC_LONG(input.count), &digest)
        }
        return Data(digest)
    }
}
