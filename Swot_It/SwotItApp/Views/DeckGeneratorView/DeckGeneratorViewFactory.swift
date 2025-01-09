import SwiftUI

struct DeckGeneratorViewFactory {
    let handler: DeckGeneratorViewHandler

    @ViewBuilder
    func make() -> some View {
        DeckGeneratorView(
            handler: handler
        )
        .tabItem {
            Image(systemName: "hammer")
            Text("Build")
        }
    }
}
