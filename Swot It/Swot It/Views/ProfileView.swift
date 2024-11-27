import SwiftUI

protocol ProfileViewHandler {
    func onViewAppear()
    func accessTokenSaved()
}

struct ProfileView: View {
    
    @EnvironmentObject private var model: SwotItModel
    let handler: ProfileViewHandler
    
    var body: some View {
        VStack {
            Text("Profile")
                .font(.largeTitle)
                .padding()
            
            TextField(
                "Enter Access Token",
                text: Binding(
                    $model.viewableAccessToken,
                    replacingNilWith: ""
                )
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            Button(action: {
                // Handle the access token submission
                print("Access Token: \(model.viewableAccessToken ?? "NULL")")
                handler.accessTokenSaved()
            }) {
                Text("Submit")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
        .onAppear {
            handler.onViewAppear()
        }
    }
}

public extension Binding where Value: Equatable {
    init(_ source: Binding<Value?>, replacingNilWith nilProxy: Value) {
        self.init(
            get: { source.wrappedValue ?? nilProxy },
            set: { newValue in
                if newValue == nilProxy { source.wrappedValue = nil }
                else { source.wrappedValue = newValue }
            }
        )
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(handler: MockProfileViewHandler())
    }
    
    struct MockProfileViewHandler: ProfileViewHandler {
        func onViewAppear() {
            print("Mock: View appeared")
        }
        
        func accessTokenSaved() {
            print("Mock: Access token saved")
        }
    }
}
