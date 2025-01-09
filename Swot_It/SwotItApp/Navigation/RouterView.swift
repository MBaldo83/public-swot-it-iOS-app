import SwiftUI

struct RouterView<Content: View>: View {
    
    @State var router: Router
    // Our root view content
    private let content: Content
    
    init(router: Router,
         @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.router = router
    }
    
    var body: some View {
        NavigationStack(path: $router.routePath) {
            content
                .navigationDestination(for: Router.Route.self) { route in
                    router.view(for: route)
                }
        }
        .environment(router)
    }
}
