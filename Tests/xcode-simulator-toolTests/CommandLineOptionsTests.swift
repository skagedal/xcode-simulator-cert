
import XCTest
import SPMUtility
@testable import XcodeSimulatorKit

class CommandLineOptionsTests: XCTestCase {
    func testListDevices() throws {
        let options = try CommandLineOptions.parse(commandName: "command", arguments: ["list-devices"])
        XCTAssertEqual(options.subCommand, .listDevices)
    }

    func testArgumentParser() throws {
        let parser = ArgumentParser(commandName: "SomeBinary", usage: "sample parser", overview: "Sample overview")

        parser.add(subparser: "a", overview: "A!")
        parser.add(subparser: "b", overview: "B!")

        let result = try parser.parse(["a"])
        XCTAssertEqual(result.subparser(parser), "a")
    }
}
