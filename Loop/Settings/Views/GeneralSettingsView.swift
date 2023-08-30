//
//  GeneralSettingsView.swift
//  Loop
//
//  Created by Kai Azim on 2023-01-24.
//

import SwiftUI
import Defaults
import ServiceManagement

struct GeneralSettingsView: View {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @Default(.launchAtLogin) var launchAtLogin
    @Default(.useSystemAccentColor) var useSystemAccentColor
    @Default(.customAccentColor) var customAccentColor
    @Default(.useGradient) var useGradient
    @Default(.gradientColor) var gradientColor
    @Default(.currentIcon) var currentIcon
    @Default(.timesLooped) var timesLooped

    let iconManager = IconManager()
    let accessibilityAccessManager = AccessibilityAccessManager()

    @State var isAccessibilityAccessGranted = false

    var body: some View {
        Form {
            Section("Behavior") {
                Toggle("Launch at login", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { _ in
                        if launchAtLogin {
                            try? SMAppService().register()
                        } else {
                            try? SMAppService().unregister()
                        }
                    }
            }

            Section("Loop's icon") {
                VStack(alignment: .leading) {
                    Picker("Selected icon:", selection: $currentIcon) {
                        ForEach(iconManager.returnUnlockedIcons(), id: \.self) { icon in
                            Text(iconManager.nameWithoutPrefix(name: icon)).tag(icon)
                        }
                    }
                    Text("Loop more to unlock more icons! (You've looped \(timesLooped) times!)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textSelection(.enabled)
                }
            }

            Section("Accent Color") {
                Toggle("Use System Accent Color", isOn: $useSystemAccentColor)

                if !useSystemAccentColor {
                    ColorPicker("Custom Accent Color", selection: $customAccentColor, supportsOpacity: false)
                }

                Toggle("Use Gradient", isOn: $useGradient)

                if !useSystemAccentColor && useGradient {
                    ColorPicker("Custom Gradient color", selection: $gradientColor, supportsOpacity: false)
                        .foregroundColor(
                            useGradient ? (useSystemAccentColor ? .secondary : nil) : .secondary
                        )
                }
            }

            Section(content: {
                HStack {
                    Text("Accessibility Access")
                    Spacer()
                    Text(isAccessibilityAccessGranted ? "Granted" : "Not Granted")
                    Circle()
                        .frame(width: 8, height: 8)
                        .padding(.trailing, 5)
                        .foregroundColor(isAccessibilityAccessGranted ? .green : .red)
                        .shadow(color: isAccessibilityAccessGranted ? .green : .red, radius: 8)
                }
            }, header: {
                HStack {
                    Text("Permissions")

                    Spacer()

                    Button("Refresh Status", action: {
                        self.isAccessibilityAccessGranted = accessibilityAccessManager.requestAccess()
                    })
                    .buttonStyle(.link)
                    .foregroundStyle(Color.accentColor)
                    .disabled(isAccessibilityAccessGranted)
                    .opacity(isAccessibilityAccessGranted ? 0.6 : 1)
                    .help("Refresh the current accessibility permissions")
                    .onAppear {
                        self.isAccessibilityAccessGranted = accessibilityAccessManager.getStatus()
                    }
                }
            })
        }
        .formStyle(.grouped)
    }
}
