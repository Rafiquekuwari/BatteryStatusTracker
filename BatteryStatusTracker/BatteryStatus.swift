//
//  BatteryStatus.swift
//  BatteryStatusTracker
//
//  Created by Mohammad Rafique Kuwari on 22/12/24.
//

// MARK: - BatteryStatus
import SwiftUI
import AuthenticationServices
import UserNotifications
import CloudKit

class BatteryStatus: ObservableObject {
    @Published var level: Float = UIDevice.current.batteryLevel
    @Published var state: UIDevice.BatteryState = UIDevice.current.batteryState

    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(forName: UIDevice.batteryLevelDidChangeNotification, object: nil, queue: .main) { _ in
            self.level = UIDevice.current.batteryLevel
        }
        NotificationCenter.default.addObserver(forName: UIDevice.batteryStateDidChangeNotification, object: nil, queue: .main) { _ in
            self.state = UIDevice.current.batteryState
        }
    }
}
