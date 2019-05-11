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
}
