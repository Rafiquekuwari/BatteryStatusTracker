//
//  sendBatteryNotification.swift
//  BatteryStatusTracker
//
//  Created by Mohammad Rafique Kuwari on 22/12/24.
//

// MARK: - Notifications
import SwiftUI
import AuthenticationServices
import UserNotifications
import CloudKit

func sendBatteryNotification(deviceName: String, batteryLevel: Float) {
    let content = UNMutableNotificationContent()
    content.title = "Low Battery Alert"
    content.body = "\(deviceName) is at \(batteryLevel * 100)% battery."
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
}
