import Foundation
import SPMUtility

struct ListDevicesCommand: Command {
    let name = "list-devices"
    let overview = "List available Xcode Simulator devices"

    private let binder = ArgumentBinder<ListDevicesCommand>()
    private var filteringOptions = FilteringOptions()

    func addOptions(to parser: ArgumentParser) {
        binder.bind(option: parser.add(
            option: "--availability",
            kind: FilteringOptions.Availability.self,
            usage: "Only list available devices? yes|no|all, defaults to all"
        ), to: { command, availability in
            command.filteringOptions.availability = availability
        })
    }

    mutating func fillParseResult(_ parseResult: ArgumentParser.Result) throws {
        try binder.fill(parseResult: parseResult, into: &self)
    }

    func run() throws {
        let allDevices = try Simctl.listDevices()
        for (runtime, devices) in allDevices.devices {
            let filteredDevices = devices.filter(using: filteringOptions)
            guard !filteredDevices.isEmpty else {
                continue
            }
            print("\(runtime):")
            for device in filteredDevices {
                print(" - \(device.name)")
                let trustStore = TrustStore(uuid: device.udid)
                if trustStore.exists {
                    print(" - Trust store exists at \(trustStore.path)")
                }
            }
        }
    }
}

extension FilteringOptions.Availability {
    func matches(_ availability: Bool) -> Bool {
        switch (self, availability) {
        case (.yes, true), (.no, false), (.all, _):
            return true
        case (.yes, false), (.no, true):
            return false
        }
    }
}

extension Sequence where Element == Simctl.Device {
    func filter(using filteringOptions: FilteringOptions) -> [Simctl.Device] {
        return filter { device in
            filteringOptions.availability.matches(device.isAvailable)
        }
    }
}
