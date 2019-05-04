import Foundation
import Basic
import SPMUtility

struct CommandLineOptions {
    enum SubCommand {
        case noCommand
        case version
        case listDevices
    }

    struct Error: Swift.Error {
        let underlyingError: Swift.Error
        private let argumentParser: ArgumentParser

        fileprivate init(underlyingError: Swift.Error, argumentParser: ArgumentParser) {
            self.underlyingError = underlyingError
            self.argumentParser = argumentParser
        }

        func printUsage(on stream: OutputByteStream) {
            argumentParser.printUsage(on: stream)
        }
    }

    private let parser: ArgumentParser
    private(set) var subCommand: SubCommand

    static func parse(commandName: String, arguments: [String]) throws -> CommandLineOptions {
        let parser = ArgumentParser(
            commandName: commandName,
            usage: "[options] subcommand",
            overview: "Manage Xcode simulators",
            seeAlso: nil
        )

        let binder = ArgumentBinder<CommandLineOptions>()

        binder.bind(option: parser.add(
            option: "--version",
            shortName: "-v",
            kind: Bool.self,
            usage: "Prints the version and exits"
        ), to: { options, _ in
            options.subCommand = .version
        })

        parser.add(
            subparser: "list-devices",
            overview: "List available Xcode Simulator devices"
        )

        var options = CommandLineOptions(parser: parser, subCommand: .noCommand)
        do {
            let result = try parser.parse(arguments)
            switch result.subparser(parser) {
            case "list-devices":
                options.subCommand = .listDevices
            default:
                try binder.fill(parseResult: result, into: &options)
            }
        } catch {
            throw Error(underlyingError: error, argumentParser: parser)
        }
        return options
    }

    func printUsage(on stream: OutputByteStream) {
        parser.printUsage(on: stream)
    }
}
