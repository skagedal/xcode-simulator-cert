//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Foundation

class InstallCommandRunner {
    private let reporter: Reporter
    private let options: InstallCommand.Options
    private let filteringOptions: FilteringOptions

    init(
        options: InstallCommand.Options,
        filteringOptions: FilteringOptions,
        reporter: Reporter) {
        self.reporter = reporter
        self.options = options
        self.filteringOptions = filteringOptions
    }

    func run() throws {
        let url = URL(fileURLWithPath: options.path!)
        let certificate = try Certificate.load(from: url)

        for device in try Simctl.flatListDevices().filter(using: filteringOptions) {
            try self.install(certificate, in: device)
        }
    }

    private func install(_ certificate: Certificate, in device: Simctl.Device) throws {
        let sha1 = certificate.sha1
        let certificateName = certificate.subjectSummary ?? "<unknown certificate>"

        let trustStore = TrustStore(uuid: device.udid)
        reporter.info("Trust store path: \(trustStore.path)")
        if !trustStore.exists {
            reporter.info("Trust store does not exist yet.")
            if options.dryRun {
                print("Would install '\(certificateName)' into '\(device.name)'.")
                return
            }
            reporter.info("Creating directories.")
            try trustStore.createParentDirectories()
        }

        let connection = try trustStore.open()
        reporter.info("Opened trust store.")

        try connection.setupDatabaseIfNeeded(reporter: reporter)

        if try connection.hasCertificate(with: sha1) {
            if options.dryRun {
                print("Would skip installing '\(certificateName)' into '\(device.name)' – it's already there.")
            } else {
                print("Not installing '\(certificateName)' into '\(device.name)' – it's already there.")
            }
            return
        }

        if options.dryRun {
            print("Would install '\(certificateName)' into '\(device.name)'.")
        } else {
            print("Installing '\(certificateName)' into '\(device.name)'.")
            try trustStore.open().addCertificate(certificate)
        }

    }
}
