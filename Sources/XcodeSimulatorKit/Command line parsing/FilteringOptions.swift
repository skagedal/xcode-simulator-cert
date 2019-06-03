//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Foundation
import SPMUtility

struct FilteringOptions {
    enum Availability: String, StringEnumArgument {
        case yes
        case no
        case all

        public static var completion: ShellCompletion = .none
    }

    var availability: Availability = .yes
    var deviceName: String?
}

extension ArgumentBinder where Options == FilteringOptions {
    func bind(_ parser: ArgumentParser) {
        bind(option: parser.add(
            option: "--availability",
            kind: FilteringOptions.Availability.self,
            usage: "Only affect available devices? yes|no|all, defaults to all"
        ), to: { options, availability in
            options.availability = availability
        })

        bind(option: parser.add(
            option: "--device-name",
            kind: String.self,
            usage: "Only affect devices with an exact name"
        ), to: { options, name in
            options.deviceName = name
        })
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
            if let deviceName = filteringOptions.deviceName, deviceName != device.name {
                return false
            }
            return filteringOptions.availability.matches(device.isAvailable)
        }
    }
}
