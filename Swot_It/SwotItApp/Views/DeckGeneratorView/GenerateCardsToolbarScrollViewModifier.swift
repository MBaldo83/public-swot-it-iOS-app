import SwiftUI

// Custom View Modifier
struct HeightOffsetScrollViewOverlay<PreferenceKeyType: PreferenceKey,
                                     OverlayContentView: View>: ViewModifier where PreferenceKeyType.Value == CGFloat {
    
    @State var scrollOffset: CGFloat = 0
    let coordinateSpaceName: String
    let heightOffsetThreshold: CGFloat
    let preferenceKey: PreferenceKeyType.Type
    let overlayContentView: () -> OverlayContentView
    
    func body(content: Content) -> some View {
        content
            .coordinateSpace(name: coordinateSpaceName)
            .onPreferenceChange(preferenceKey) { value in
                scrollOffset = value
            }
            .overlay(alignment: .top) {
                overlayContentView()
                    .opacity(overlayOpacity)
                    .animation(.easeInOut, value: scrollOffset)
                    .compositingGroup()
                    .shadow(radius: 5)
            }
    }
    
    var overlayOpacity: Double {
        let fadeInThreshold = -heightOffsetThreshold
        let fullyVisibleThreshold = fadeInThreshold - 50
        if scrollOffset > fadeInThreshold {
            return 0
        } else if scrollOffset < fullyVisibleThreshold {
            return 1
        } else {
            return Double((fadeInThreshold - scrollOffset) / (fadeInThreshold - fullyVisibleThreshold))
        }
    }
}

// Extension for easy application
extension View {
    func applyHeightOffsetScrollViewOverlay<PreferenceKeyType: PreferenceKey, OverlayContentView: View>(
        coordinateSpaceName: String,
        heightOffsetThreshold: CGFloat,
        preferenceKey: PreferenceKeyType.Type,
        overlayContentView: @escaping () -> OverlayContentView
    ) -> some View where PreferenceKeyType.Value == CGFloat {
        self.modifier(HeightOffsetScrollViewOverlay(
            coordinateSpaceName: coordinateSpaceName,
            heightOffsetThreshold: heightOffsetThreshold,
            preferenceKey: preferenceKey,
            overlayContentView: overlayContentView
        ))
    }
}
