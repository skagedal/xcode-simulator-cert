import Foundation
import XCTest
@testable import XcodeSimulatorKit

class SimctlTests: XCTestCase {
    func testListDevices() throws {
        let jsonData: Data = try Simctl.readListDevices()
        let obj = try JSONSerialization.jsonObject(with: jsonData, options: [])
        XCTAssertTrue(obj is [String: Any])
        guard let dict = obj as? [String: Any] else {
            return
        }
        XCTAssertEqual(dict.keys.count, 1)
        XCTAssertEqual(dict.keys.first, "devices")

        XCTAssertNoThrow(try Simctl.parseDeviceList(jsonData))
        _ = try Simctl.parseDeviceList(jsonData)
    }
}
