//
//  ContentView.swift
//  BatteryStatusTracker
//
//  Created by Mohammad Rafique Kuwari on 22/12/24.
//

import SwiftUI
import AuthenticationServices
import CloudKit

struct ContentView: View {
    @State private var signedIn: Bool = false

    var body: some View {
        if signedIn {
            DeviceListView()
        } else {
            SignInWithAppleView(onSignIn: { signedIn = true })
        }
    }
}

// MARK: - SignInWithAppleView
struct SignInWithAppleView: UIViewRepresentable {
    var onSignIn: () -> Void

    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(context.coordinator, action: #selector(Coordinator.handleAuthorizationAppleID), for: .touchUpInside)
        return button
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(onSignIn: onSignIn)
    }

    class Coordinator: NSObject, ASAuthorizationControllerDelegate {
        var onSignIn: () -> Void

        init(onSignIn: @escaping () -> Void) {
            self.onSignIn = onSignIn
        }

        @objc func handleAuthorizationAppleID() {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.performRequests()
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let _ = authorization.credential as? ASAuthorizationAppleIDCredential {
                onSignIn()
            }
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print("Error signing in: \(error.localizedDescription)")
        }
    }
}
// MARK: - DeviceListView
struct DeviceListView: View {
    @State private var devices: [CKRecord] = []

    var body: some View {
        List(devices, id: \.recordID) { record in
            VStack(alignment: .leading) {
                Text(record["deviceName"] as? String ?? "Unknown Device")
                    .font(.headline)
                Text("Battery Level: \((record["batteryLevel"] as? Float ?? 0) * 100)%")
                    .font(.subheadline)
            }
        }
        .onAppear(perform: fetchDevices)
    }

    func fetchDevices() {
        let cloudKitHelper = CloudKitHelper()
        cloudKitHelper.fetchBatteryData { records in
            DispatchQueue.main.async {
                devices = records
            }
        }
    }
}
#Preview {
    ContentView()
}
