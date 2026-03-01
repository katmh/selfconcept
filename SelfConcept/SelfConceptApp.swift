import SwiftUI

@main
struct SelfConceptApp: App {
    @State var viewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
    }
}
