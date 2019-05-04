import Foundation
import XCTest
@testable import XcodeSimulatorKit

class SimctlTests: XCTestCase {
    func testListDevices() throws {
        let jsonData = try Simctl.listDevices()
        let obj = try JSONSerialization.jsonObject(with: jsonData, options: [])
        XCTAssertTrue(obj is [String: Any])
        guard let dict = obj as? [String: Any] else {
            return
        }
        XCTAssertEqual(dict.keys.count, 1)
        XCTAssertEqual(dict.keys.first, "devices")
    }
}
