import SwiftUI

protocol RootTabViewHandler {
    var buildDeckViewHandler: DeckGeneratorViewHandler { get }
}

struct RootTabView<TabZero: View, TabOne: View, TabTwo: View>: View {
    @State private var selectedTab = 0
    let buildTabZero: () -> TabZero
    let buildTabOne: () -> TabOne
    let buildTabTwo: () -> TabTwo
    
    var body: some View {
        TabView(selection: $selectedTab) {
            buildTabZero()
                .tag(0)
            buildTabOne()
                .tag(1)
            buildTabTwo()
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView(
            buildTabZero: {
                Color.blue
            },
            buildTabOne: {
                Color.red
            },
            buildTabTwo: {
                Color.green
            }
        )
    }
}
