//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Foundation

struct TrustStoreRow {
    let subj: Data
    let sha1: Data
    let tset: Data?
    let data: Data?
}

extension TrustStoreRow {
    enum Error: LocalizedError {
        case noTsetValue
        case noData
        case subjectContentDoesNotMatch
        case sha1DoesNotMatch
        case tsetNotValid

        var errorDescription: String? {
            switch self {
            case .noTsetValue:
                return "No tset data was found"
            case .tsetNotValid:
                return "Format of tset data was not valid"
            case .noData:
                return "No certificate data was found"
            case .subjectContentDoesNotMatch:
                return "The content of the subject column did not match expectations"
            case .sha1DoesNotMatch:
                return "SHA-1 hash did not match"
            }
        }
    }

    func validatedCertificate() throws -> Certificate {
        guard let tset = tset else {
            throw Error.noTsetValue
        }
        guard let data = data else {
            throw Error.noData
        }
        let certificate = try Certificate(data)
        let subjectContent = try certificate.normalizedSubjectContent()
        let tlv = try DERParser().parse(data: subjectContent)

        guard tlv.data == subj else {
            throw Error.subjectContentDoesNotMatch
        }

        guard sha1 == Digest.sha1(data) else {
            throw Error.sha1DoesNotMatch
        }

        guard isValidTset(tset) else {
            throw Error.tsetNotValid
        }

        return certificate
    }

    private func isValidTset(_ data: Data) -> Bool {
        do {
            let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
            return plist is [Any]
        } catch {
            return false
        }
    }
}
