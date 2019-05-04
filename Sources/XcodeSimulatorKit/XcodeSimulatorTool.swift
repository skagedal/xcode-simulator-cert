import Foundation

public class XcodeSimulatorTool {
    private let arguments: [String]

    public init(arguments: [String]) {
        self.arguments = arguments
    }

    public func run() -> Int32 {
        print("Hello from XcodeSimulatorTool")
        return 0
    }
}
