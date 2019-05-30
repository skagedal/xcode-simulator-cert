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

    init(_ certificate: Certificate) throws {
        let data = certificate.data
        self.data = data
        self.sha1 = Digest.sha1(data)
        self.tset = createTset()
        self.subj = try subjectContent(from: certificate)
        assert(isValidTset(self.tset!))
    }

    func validatedCertificate() throws -> Certificate {
        guard let tset = tset else {
            throw Error.noTsetValue
        }
        guard let data = data else {
            throw Error.noData
        }
        let certificate = try Certificate(data)
        let subject = try subjectContent(from: certificate)

        guard subject == subj else {
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
}

private func subjectContent(from certificate: Certificate) throws -> Data {
    let subjectContent = try certificate.normalizedSubjectContent()
    let tlv = try DERParser().parse(data: subjectContent)
    return tlv.data
}

private func isValidTset(_ data: Data) -> Bool {
    do {
        let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
        return plist is [Any]
    } catch {
        return false
    }
}

private func createTset() -> Data {
    do {
        return try PropertyListSerialization.data(fromPropertyList: [], format: .xml, options: 0)
    } catch {
        fatalError("Should be able to create propertylist")
    }
}
