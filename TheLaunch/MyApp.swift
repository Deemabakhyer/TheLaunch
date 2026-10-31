import SwiftUI

@main
struct MyApp: App {
    
    @State private var taskStore = TaskStore()
    @AppStorage("hasCompletedOnboarding")
    private var hasCompletedOnboarding = false
    
     var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    RootView()
                        .environment(taskStore)

                } else {
                    ChooseABuddy()
                        .environment(taskStore)

                }
            }

        }
    }
}
