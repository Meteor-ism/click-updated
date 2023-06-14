import SwiftUI

@main
struct MyApp: App {
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .purple
    }
    var body: some Scene {
        WindowGroup {
            ContentView().accentColor(.purple)
        }
    }
}
