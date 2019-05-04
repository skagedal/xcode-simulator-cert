import Foundation
import SPMUtility

struct ListDevicesCommand {
    func run() throws {
        let allDevices = try Simctl.listDevices()
        for (runtime, devices) in allDevices.devices {
            print("\(runtime):")
            for device in devices {
                print(" - \(device.name)")
            }
        }
    }
}
