import Foundation
import Basic
import SPMUtility

struct Simctl {
    enum Error: Swift.Error {
        case listDevices(errorOutput: String)
    }

    static func listDevices() throws -> Data {
        let process = Process(
            args: "xcrun", "simctl", "list", "--json", "devices"
        )
        try process.launch()
        let result = try process.waitUntilExit()
        guard result.exitStatus == .terminated(code: 0) else {
            let errorOutput = try (result.utf8Output() + result.utf8stderrOutput()).spm_chuzzle() ?? ""
            throw Error.listDevices(errorOutput: errorOutput)
        }

        switch result.output {
        case .success(let bytes):
            return Data(bytes)
        case .failure(let error):
            throw error
        }
    }
}
