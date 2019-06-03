//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Foundation
import SPMUtility

class InstallCACommand: Command {
    private struct Options {
        var path: String?
        var dryRun: Bool = false
    }
    let name = "install-ca"
    let overview = "Install a Certificate Authority"

    private let binder = ArgumentBinder<Options>()
    private var options = Options()

    private let filteringBinder = ArgumentBinder<FilteringOptions>()
    private var filteringOptions = FilteringOptions()

    func addOptions(to parser: ArgumentParser) {
        binder.bind(option: parser.add(
            option: "--dry-run",
            kind: Bool.self,
            usage: "Don't actually install any CA"
            ), to: { options, dryRun in
            options.dryRun = dryRun
        })

        binder.bind(positional: parser.add(
            positional: "path",
            kind: String.self,
            usage: "Path for the certificate to install"
        ), to: { options, path in
            options.path = path
        })

        filteringBinder.bind(parser)
    }

    func fillParseResult(_ parseResult: ArgumentParser.Result) throws {
        try binder.fill(parseResult: parseResult, into: &options)
        try filteringBinder.fill(parseResult: parseResult, into: &filteringOptions)
    }

    func run(reporter: Reporter) throws {
        let url = URL(fileURLWithPath: options.path!)
        let certificate = try Certificate.load(from: url)
        let sha1 = certificate.sha1

        let certificateName = certificate.subjectSummary ?? "<unknown certificate>"

        for device in try Simctl.flatListDevices().filter(using: filteringOptions) {
            let trustStore = TrustStore(uuid: device.udid)
            if !trustStore.exists && options.dryRun {
                print("Would install '\(certificateName)' into '\(device.name)'.")
                continue
            }

            let connection = try trustStore.open()
            if try connection.hasCertificate(with: sha1) {
                if options.dryRun {
                    print("Would skip installing '\(certificateName)' into '\(device.name)' – it's already there.")
                } else {
                    print("Not installing '\(certificateName)' into '\(device.name)' – it's already there.")
                }
                continue
            }

            if options.dryRun {
                print("Would install '\(certificateName)' into '\(device.name)'.")
            } else {
                print("Installing '\(certificateName)' into '\(device.name)'.")
                try trustStore.open().addCertificate(certificate)
            }
        }
    }

}
