import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(xcode_simulator_toolTests.allTests),
    ]
}
#endif
