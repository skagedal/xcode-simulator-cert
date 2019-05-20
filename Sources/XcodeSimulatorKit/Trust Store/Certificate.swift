//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Foundation
import Security

struct Certificate {
    enum Error: LocalizedError {
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

    private let certificate: SecCertificate

    init(_ data: Data) throws {
        guard let certificate = SecCertificateCreateWithData(nil, data as CFData) else {
            throw Error.invalidDERX509
        }
        self.certificate = certificate
    }

    var subjectSummary: String? {
        return SecCertificateCopySubjectSummary(certificate) as String?
    }

    func normalizedSubjectSequence() throws -> Data {
        var error: Unmanaged<CFError>?
        guard let data = SecCertificateCopyNormalizedSubjectContent(certificate, &error) else {
            guard let error = error else {
                throw Error.unknown
            }
            throw error.takeRetainedValue()
        }
        return data as Data
    }

    func normalizedSubjectContent() throws -> Data {
        var error: Unmanaged<CFError>?
        guard let data = SecCertificateCopyNormalizedSubjectContent(certificate, &error) else {
            guard let error = error else {
                throw Error.unknown
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
