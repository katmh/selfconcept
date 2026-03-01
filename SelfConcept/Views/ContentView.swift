import SwiftUI

struct ContentView: View {
    @Environment(AppViewModel.self) var viewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ReadView()
                .tabItem {
                    Label("Read", systemImage: "eye")
                }
                .tag(0)

            WriteView()
                .tabItem {
                    Label("Write", systemImage: "pencil")
                }
                .tag(1)
        }
    }
}

#Preview {
    ContentView()
        .environment(AppViewModel())
}
