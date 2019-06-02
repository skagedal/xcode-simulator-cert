//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Foundation
import Security

struct Certificate {
    enum Error: LocalizedError {
        case invalidDERX509
        case importError(OSStatus)
        case exportError(OSStatus)
        case exportNoData
        case notACertficate
        case unknown

        var errorDescription: String? {
            switch self {
            case .invalidDERX509:
                return "Given data was not a valid DER encoded X.509 certificate"
            case .importError(let status):
                return "Error from SecItemImport: \(status)"
            case .exportError(let status):
                return "Error from SecItemExport: \(status)"
            case .exportNoData:
                return "No data returned from SecItemExport"
            case .notACertficate:
                return "SecItemImport gave something else than a certificate"
            case .unknown:
                return "Operation completed with an unknown error from the Security framework"
            }
        }
    }

    let data: Data
    private let certificate: SecCertificate

    init(_ data: Data) throws {
        guard let certificate = SecCertificateCreateWithData(nil, data as CFData) else {
            throw Error.invalidDERX509
        }
        self.data = data
        self.certificate = certificate
    }

    var subjectSummary: String? {
        return SecCertificateCopySubjectSummary(certificate) as String?
    }

    var sha1: Data {
        return Digest.sha1(data)
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

    static func load(from url: URL) throws -> Certificate {
        let data = try Data(contentsOf: url)

        var cfitems: CFArray?
        var format = SecExternalFormat.formatUnknown
        var type = SecExternalItemType.itemTypeUnknown

        let status = SecItemImport(data as CFData, url.lastPathComponent as CFString, &format, &type, [], nil, nil, &cfitems)
        guard status == errSecSuccess else {
            throw Error.importError(status)
        }
        guard type == .itemTypeCertificate, let items = cfitems as? [SecCertificate], let item = items.first else {
            throw Error.notACertficate
        }
        let certData = SecCertificateCopyData(item) as Data
        return try Certificate(certData)
    }

    func exportPEM() throws -> Data {
        var cfData: CFData?
        let status = withUnsafeMutablePointer(to: &cfData) { pointer in
            SecItemExport(certificate, .formatX509Cert, .pemArmour, nil, pointer)
        }
        guard status == errSecSuccess else {
            throw Error.exportError(status)
        }
        guard let data = cfData else {
            throw Error.exportNoData
        }
        return data as Data
    }
}
