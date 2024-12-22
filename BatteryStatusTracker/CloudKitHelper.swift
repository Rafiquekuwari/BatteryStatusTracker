//
//  CloudKitHelper.swift
//  BatteryStatusTracker
//
//  Created by Mohammad Rafique Kuwari on 22/12/24.
//

// MARK: - CloudKitHelper
import SwiftUI
import AuthenticationServices
import UserNotifications
import CloudKit

class CloudKitHelper {
    private let database = CKContainer.default().privateCloudDatabase

    func fetchBatteryData(completion: @escaping ([CKRecord]) -> Void) {
        let query = CKQuery(recordType: "BatteryStatus", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { records, error in
            if let records = records {
                completion(records)
            } else if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion([])
            }
        }
    }
}
