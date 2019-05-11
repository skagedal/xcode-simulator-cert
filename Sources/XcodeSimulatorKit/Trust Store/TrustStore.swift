import Foundation
import Basic
import SQLite

struct TrustStore {
    let uuid: String
    let path: AbsolutePath

    init(uuid: String) {
        self.uuid = uuid
        self.path = XcodeSimulator.trustStore(forDeviceWithUUID: uuid)
    }

    var exists: Bool {
        return localFileSystem.exists(path)
    }

    func open() throws -> Connection {
        return try Connection(openingPath: path.pathString)
    }

    class Connection {
        private let connection: SQLite.Connection
        private let sqliteMaster = Table("sqlite_master")
        private let tsettings = Table("tsettings")
        private let dataColumn = Expression<Blob?>("data")

        fileprivate init(openingPath path: String) throws {
            connection = try SQLite.Connection(path)
        }

        func isValid() -> Bool {
            do {
                guard let count = try connection.scalar(
                    "SELECT count(*) FROM sqlite_master WHERE type='table' AND name='tsettings'"
                ) as? Int64 else {
                    return false
                }
                return count > 0
            } catch {
                return false
            }
        }

        func certificates() throws -> [Certificate] {
            return try connection.prepare(tsettings).compactMap { row in
                try row[dataColumn].map { blob in
                    try Certificate(Data(blob.bytes))
                }
            }
        }
    }
}
