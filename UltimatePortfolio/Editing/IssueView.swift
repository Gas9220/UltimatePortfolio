//
//  IssueView.swift
//  UltimatePortfolio
//
//  Created by Gaspare Monte on 08/02/24.
//

import SwiftUI

struct IssueView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var issue: Issue

    @State private var showingNotificationError = false
    @Environment(\.openURL) var openURL

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    TextField("Title", text: $issue.issueTitle, prompt: Text("Enter the issue title here"))
                        .font(.title)

                    Text("**Modified** \(issue.issueModification.formatted(date: .long, time: .shortened))")
                        .foregroundStyle(.secondary)

                    Text("**Status**: \(issue.issueStatus)")
                        .foregroundStyle(.secondary)
                }

                Picker("Priority", selection: $issue.priority) {
                    Text("Low").tag(Int16(0))
                    Text("Medium").tag(Int16(1))
                    Text("High").tag(Int16(2))
                }
                TagsMenuView(issue: issue)
            }

            Section {
                VStack(alignment: .leading) {
                    Text("Basic Information")
                        .font(.title2)
                        .foregroundStyle(.secondary)

                    TextField(
                        "Issue Description",
                        text: $issue.issueContent,
                        prompt: Text("Enter the issue description here"),
                        axis: .vertical
                    )
                }
            }

            Section("Reminders") {
                Toggle("Show reminders", isOn: $issue.reminderEnabled.animation())

                if issue.reminderEnabled {
                    DatePicker(
                        "Reminder time",
                        selection: $issue.issueReminderTime,
                        displayedComponents: .hourAndMinute
                    )
                }
            }
        }
        .disabled(issue.isDeleted)
        .onReceive(issue.objectWillChange) { _ in
            dataController.queueSave()
        }
        .onSubmit(dataController.save)
        .toolbar {
            IssueViewToolbar(issue: issue)
        }
        .alert("Oops!", isPresented: $showingNotificationError) {
            Button("Check Settings", action: showAppSettings)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("There was a problem setting your notification. Please check you have notifications enabled.")
        }
        .onChange(of: issue.reminderEnabled) { _ in
            updateReminder()
        }
        .onChange(of: issue.reminderTime) { _ in
            updateReminder()
        }
    }

    func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString) else {
            return
        }

        openURL(settingsURL)
    }

    func updateReminder() {
        dataController.removeReminders(for: issue)

        Task { @MainActor in
            if issue.reminderEnabled {
                let success = await dataController.addReminder(for: issue)

                if success == false {
                    issue.reminderEnabled = false
                    showingNotificationError = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        IssueView(issue: .example)
            .environmentObject(DataController.preview)
    }
}
