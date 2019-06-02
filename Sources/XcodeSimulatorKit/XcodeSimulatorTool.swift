//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Foundation
import Basic
import SPMUtility

public class XcodeSimulatorTool {
    private let arguments: [String]

    public init(arguments: [String]) {
        self.arguments = arguments
    }

    public func run() -> Int32 {
        let commandName = URL(fileURLWithPath: arguments.first!).lastPathComponent
        let arguments = Array(self.arguments.dropFirst())

        do {
            let options = try CommandLineOptions.parse(
                commandName: commandName,
                arguments: arguments
            )
            try run(with: options)
        } catch let error as CommandLineOptions.Error {
            stderrStream.write("error: \(error.underlyingError)\n\n")
            error.printUsage(on: stderrStream)
            return 1
        } catch {
            debugPrint(error)
            return 2
        }
        return 0
    }

    private func run(with options: CommandLineOptions) throws {
        switch options.subCommand {
        case .noCommand:
            options.printUsage(on: stdoutStream)
        case .version:
            print("xcode-simulator-tool version \(XcodeSimulatorTool.version)")
        case .command(let command):
            try command.run()
        }
    }
}
