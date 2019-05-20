//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Foundation

/// A very minimal DER parser
struct DERParser {
    enum TagClass: UInt8 {
        case universal = 0
        case application = 1
        case contentSpecific = 2
        case `private` = 3
    }
    struct TLV {
        let tagClass: TagClass
        let isConstructed: Bool
        let tagNumber: Int
        let data: Data
    }

    enum Error: Swift.Error {
        case parseError(String)
    }

    func parse(data: Data) throws -> TLV {
        var iterator = data.makeIterator()
        guard let tlv = try parse(iterator: &iterator) else {
            throw Error.parseError("Expected DER contents")
        }
        return tlv
    }

    func parse(iterator: inout Data.Iterator) throws -> TLV? {
        guard let identifier = iterator.next() else {
            return nil
        }
        let tagClass = TagClass(rawValue: identifier >> 6)!
        let isConstructed = (identifier & 0b0010_0000) == 0b0010_0000
        let tagNumber = Int(identifier & 0b0001_1111)
        let length = try parseLength(&iterator)
        var data = Data(count: length)
        for index in data.indices {
            guard let byte = iterator.next() else {
                throw Error.parseError("Expected \(length) bytes of data, got \(index)")
            }
            data[index] = byte
        }
        return TLV(
            tagClass: tagClass,
            isConstructed: isConstructed,
            tagNumber: tagNumber,
            data: data
        )
    }

    private func parseLength(_ iterator: inout Data.Iterator) throws -> Int {
        guard let firstLengthOctet = iterator.next() else {
            throw Error.parseError("Expected initial length octet")
        }

        if firstLengthOctet < 0b1000_0000 {
            return Int(firstLengthOctet)
        }

        var length: Int = 0
        let comingOctets = firstLengthOctet & 0b0111_1111
        for i in 0..<comingOctets {
            guard let x = iterator.next() else {
                throw Error.parseError("Expected \(comingOctets) length octets, got \(i)")
            }
            length = length << 8 + Int(x)
        }
        return length
    }
}
