//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Foundation
import Security

enum SecurityError: LocalizedError {
    case invalidDERX509
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidDERX509:
            return "Given data was not a valid DER encoded X.509 certificate"
        case .unknown:
            return "Operation completed with an unknown error from the Security framework"
        }
    }
}

extension SecCertificate {
    static func read(data: Data) throws -> SecCertificate {
        guard let certificate = SecCertificateCreateWithData(nil, data as CFData) else {
            throw SecurityError.invalidDERX509
        }
        return certificate
    }

    var subjectSummary: String? {
        return SecCertificateCopySubjectSummary(self) as String?
    }

    func normalizedSubjectSequence() throws -> Data {
        var error: Unmanaged<CFError>?
        guard let data = SecCertificateCopyNormalizedSubjectContent(self, &error) else {
            guard let error = error else {
                throw SecurityError.unknown
            }
            throw error.takeRetainedValue()
        }
        return data as Data
    }

    func printInfo() {
        if let summary = subjectSummary {
            print(summary)
        } else {
            print("<unknown certificate>")
        }
    }
}
