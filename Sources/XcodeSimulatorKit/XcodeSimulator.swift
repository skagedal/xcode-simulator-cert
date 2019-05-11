import Basic

class XcodeSimulator {
    static let devicesDirectory = localFileSystem.homeDirectory.appending(
        RelativePath("Library/Developer/CoreSimulator/Devices")
    )

    static func directory(forDeviceWithUUID uuid: String) -> AbsolutePath {
        return devicesDirectory.appending(component: uuid)
    }

    static func trustStore(forDeviceWithUUID uuid: String) -> AbsolutePath {
        return directory(forDeviceWithUUID: uuid).appending(
            RelativePath("data/Library/Keychains/TrustStore.sqlite3")
        )
    }
}
