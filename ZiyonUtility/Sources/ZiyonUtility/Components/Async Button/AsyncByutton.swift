//
//  AsyncButton.swift
//
//
//  Created by Elioene Silves Fernandes on 28/03/2024.
//

import SwiftUI

/// A customisable asynchronous button that supports cancellation and various configurations.
public struct AsyncButton<Label: View, Trigger: Equatable>: View {
    
    /// A trigger used to cancel an ongoing task when its value changes.
    var cancellation: Trigger
    /// The title of the button, if provided.
    var title: LocalizedStringKey?
    /// The role of the button, e.g., destructive or cancel.
    var role: ButtonRole?
    /// An optional system image name to be displayed in the button.
    var systemImage: String?
    /// The asynchronous action to perform when the button is tapped.
    let perform: () async -> Void
    /// The custom label for the button.
    @ViewBuilder let label: Label
    
    /// Tracks the current task for cancellation purposes.
    @State private var task: Task<Void, Never>?
    /// Indicates whether the button action is currently executing.
    @State private var executing: Bool = false
    
    /// Initialises an `AsyncButton` with various customisation options.
    public init(
        role: ButtonRole? = nil,
        _ title: LocalizedStringKey? = nil,
        systemImage: String? = nil,
        cancellation: Trigger = false,
        perform: @escaping () async -> Void,
        @ViewBuilder label: @escaping () -> Label = { EmptyView() }
    ) {
        self.role = role
        self.title = title
        self.systemImage = systemImage
        self.cancellation = cancellation
        self.perform = perform
        self.label = label()
    }
    
    public var body: some View {
        Group {
            if let title, let systemImage {
                /// Button with both title and system image
                Button(title, systemImage: systemImage, action: startTask)
            } else if let title {

                /// Button with title only
                Button(action: startTask) { background(Text(title)) }

            } else if let systemImage {
                /// Button with system image only
                Button(action: startTask) {
                    background(Image(systemName: systemImage))

                }
            } else {
                /// Button with custom label
                Button(role: role, action: startTask, label: { background(label) })
            }
        }
        .labelsHidden()
        .disabled(executing)
        .opacity(executing ? 0.8 : 1)
        .onChange(of: cancellation) { _,_ in
            task?.cancel()
        }
    }
    @ViewBuilder func background(_ defaultView: some View)-> some View {
        if executing {ProgressView().tint(.white)}
        else { defaultView }
    }

    /// Starts the asynchronous task and manages execution state.
    private func startTask() {
        executing = true
        task = Task {
            await perform()
            executing = false
        }
    }
}

/// A preview showcasing different variations of `AsyncButton`.
#Preview {
    if #available(iOS 16.4, *) {
        VStack {
            AsyncButton("Title") {
                try? await Task.sleep(for: .seconds(3))
            }
                .buttonStyle(.ziyon())

            AsyncButton(systemImage: "clock") {
                try? await Task.sleep(for: .seconds(3))
            }
                .buttonStyle(.ziyon())

            AsyncButton {
                try? await Task.sleep(for: .seconds(3))
            } label: {
                Label("Press me", systemImage: "gear.circle.fill")
            }
            .buttonStyle(.ziyon())

        }
        .padding(.horizontal)
        .format(color: .white)
    }
}
