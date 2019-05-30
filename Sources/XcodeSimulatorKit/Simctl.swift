//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Foundation
import Basic
import SPMUtility

struct Simctl {
    enum Error: Swift.Error {
        case listDevices(errorOutput: String)
    }

    struct DeviceList: Codable {
        var devices: [String: [Device]]
    }

    struct Device: Codable {
        enum State: String, Codable {
            case shutdown = "Shutdown"
            case booted = "Booted"
        }
        var isAvailable: Bool
        var name: String
        var udid: String
        var state: State
    }

    static func flatListDevices() throws -> [Device] {
        return try listDevices().devices.values.flatMap { $0 }
    }

    static func listDevices() throws -> DeviceList {
        return try parseDeviceList(readListDevices())
    }

    static func readListDevices() throws -> Data {
        let process = Process(
            args: "xcrun", "simctl", "list", "--json", "devices"
        )
        try process.launch()
        let result = try process.waitUntilExit()
        guard result.exitStatus == .terminated(code: 0) else {
            let errorOutput = try (result.utf8Output() + result.utf8stderrOutput()).spm_chuzzle() ?? ""
            throw Error.listDevices(errorOutput: errorOutput)
        }

        return Data(try result.output.dematerialize())
    }

    static func parseDeviceList(_ data: Data) throws -> DeviceList {
        let decoder = JSONDecoder()
        return try decoder.decode(DeviceList.self, from: data)
    }
}
