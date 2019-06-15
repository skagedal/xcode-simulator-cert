//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Foundation
import Basic
import SPMUtility

class ExportCommand: Command {
    private struct Options {
    }
    let name = "export"
    let overview = "Export Certificate Authorities"

    private let binder = ArgumentBinder<Options>()
    private var options = Options()

    private let filteringBinder = ArgumentBinder<FilteringOptions>()
    private var filteringOptions = FilteringOptions()

    private var exportedCertificates: Set<Data> = []

    func addOptions(to parser: ArgumentParser) {
        filteringBinder.bind(parser)
    }

    func fillParseResult(_ parseResult: ArgumentParser.Result) throws {
        try binder.fill(parseResult: parseResult, into: &options)
        try filteringBinder.fill(parseResult: parseResult, into: &filteringOptions)
    }

    func run(reporter: Reporter) throws {
        exportedCertificates = []
        for device in try Simctl.flatListDevices().filter(using: filteringOptions) {
            exportCertificates(for: device)
        }
    }

    private func exportCertificates(for device: Simctl.Device) {
        do {
            let store = try TrustStore(uuid: device.udid).open()
            for row in try store.rows() where !exportedCertificates.contains(row.sha1) {
                guard let data = row.data else { continue }
                do {
                    let path = try exportCertificate(from: data)
                    print("Exported PEM to \(localFileSystem.printable(path))")
                    exportedCertificates.insert(row.sha1)
                } catch {
                    print("Found invalid certificate: \(error)")
                }
            }
        } catch {
        }
    }

    private func exportCertificate(from certificateData: Data) throws -> AbsolutePath {
        let certificate = try Certificate(certificateData)
        let fileName = certificate.subjectSummary?.clean() ?? "unknown-certificate"
        let path = try localFileSystem.uniquePath(base: fileName, ext: "crt")
        let data = try certificate.exportPEM()
        try data.write(to: path.asURL)
        return path
    }
}

private extension String {
    func clean() -> String {
        return String(map { $0.isWhitespace || $0 == "/" ? "-" : $0 })
    }
}

enum FileSystemError: LocalizedError {
    case couldNotGetCurrentyWorkingDirectory

    var errorDescription: String? {
        switch self {
        case .couldNotGetCurrentyWorkingDirectory:
            return "Unable to get current working directory"
        }
    }
}

private extension FileSystem {
    /// Returns "base.ext" unless that already exists, in which case it appends a serial number until a unique path has
    /// been found: "base.ext" -> "base-1.ext" -> "base-2.ext" etc.
    func uniquePath(base: String, ext: String, count: Int? = nil) throws -> AbsolutePath {
        guard let directory = currentWorkingDirectory else {
            throw FileSystemError.couldNotGetCurrentyWorkingDirectory
        }
        let path = directory.appending(component: base + (count.map { "-\($0)" } ?? "") + "." + ext)
        if exists(path) {
            return try uniquePath(base: base, ext: ext, count: count.map { $0 + 1 } ?? 1)
        }
        return path
    }

    func printable(_ path: AbsolutePath) -> String {
        if let directory = currentWorkingDirectory {
            return path.relative(to: directory).description
        }
        return path.description
    }
}
