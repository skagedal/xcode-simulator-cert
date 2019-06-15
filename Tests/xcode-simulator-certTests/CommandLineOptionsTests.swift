
import XCTest
import Basic
import SPMUtility
@testable import XcodeSimulatorKit

class CommandLineOptionsTests: XCTestCase {
    func testListDevices() throws {
        let options = try CommandLineOptions.parse(commandName: "command", arguments: ["list-devices"])
        guard case let CommandLineOptions.SubCommand.command(command) = options.subCommand else {
            return XCTFail("Should be parsed as a command")
        }
        XCTAssertEqual(command.name, "list-devices")
    }

    func testArgumentParser() throws {
        let parser = ArgumentParser(commandName: "SomeBinary", usage: "sample parser", overview: "Sample overview")

        parser.add(subparser: "a", overview: "A!")
        parser.add(subparser: "b", overview: "B!")

        let result = try parser.parse(["a"])
        XCTAssertEqual(result.subparser(parser), "a")
    }

    func testSubParserWithOptions() throws {
        let parser = ArgumentParser(commandName: "SomeBinary", usage: "sample parser", overview: "Sample overview")
        let verboseOption = parser.add(
            option: "--verbose",
            shortName: "-v",
            kind: Bool.self,
            usage: "Print more information"
        )

        let fillCupParser = parser.add(subparser: "fill-cup", overview: "Fill cup")
        let contentOption = fillCupParser.add(
            option: "--content",
            kind: String.self,
            usage: "Specify content to fill cup with"
        )

        let result = try parser.parse(["--verbose", "fill-cup", "--content", "milk"])
        guard let foundSubparser = result.subparser(parser) else {
            return XCTFail("Expected to find a sub parser")
        }
        XCTAssertEqual(foundSubparser, "fill-cup")
        XCTAssertEqual(result.get(contentOption), "milk")

        parser.printUsage(on: stdoutStream)
        fillCupParser.printUsage(on: stdoutStream)
    }
}
