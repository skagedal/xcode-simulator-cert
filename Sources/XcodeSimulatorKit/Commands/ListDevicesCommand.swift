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
                    try listCertificates(in: trustStore)
                }
            }
        }
    }

    private func listCertificates(in trustStore: TrustStore) throws {
        let store = try trustStore.open()
        guard store.isValid() else {
            return print("   Invalid trust store at \(trustStore.path)")
        }

        var didPrintHeader = false
        for certificate in try store.certificates() {
            if !didPrintHeader {
                print("   Certificates:")
                didPrintHeader = true
            }
            print("    - \(certificate.subjectSummary ?? "<unknown certificate>")")
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
