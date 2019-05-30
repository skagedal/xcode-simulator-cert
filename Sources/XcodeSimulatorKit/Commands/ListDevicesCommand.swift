//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Foundation
import SPMUtility

class ListDevicesCommand: Command {
    let name = "list-devices"
    let overview = "List available Xcode Simulator devices"

    private let binder = ArgumentBinder<ListDevicesCommand>()
    private var filteringOptions = FilteringOptions()
    private let filteringBinder = ArgumentBinder<FilteringOptions>()

    func addOptions(to parser: ArgumentParser) {
        filteringBinder.bind(to: &filteringOptions, parser: parser)
    }

    func fillParseResult(_ parseResult: ArgumentParser.Result) throws {
        try filteringBinder.fill(parseResult: parseResult, into: &filteringOptions)
//        try binder.fill(parseResult: parseResult, into: &self)
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
        for row in try store.rows() {
            if !didPrintHeader {
                print("   Certificates:")
                didPrintHeader = true
            }
            do {
                let certificate = try row.validatedCertificate()
                print("    - \(certificate.subjectSummary ?? "<unknown certificate>")")
            } catch {
                print("    - Invalid row: \(error.localizedDescription)")
            }
        }
    }
}
