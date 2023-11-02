import SwiftUI

struct CreatePostView: View {
    @ObservedObject var vm: ViewModel = ViewModel()
    @State var userID: String = ""
    @State var selfie: String = ""
    @State var foodPic: String = ""
    @State var caption: String = ""
    @State var recipe: String = ""
    @State var location: String = ""
    var body: some View {
        VStack {
            TextField("userID", text: $userID).autocapitalization(.none)
            TextField("selfie", text: $selfie)
            TextField("foodPic", text: $foodPic)
            TextField("caption", text: $caption)
            TextField("recipe", text: $recipe)
            TextField("location", text: $location)

            Button {
                vm.firebase_create_post(userID: self.userID, selfie: self.selfie, foodPic: self.foodPic, caption: self.caption, recipe: self.recipe, location: self.location)
            } label: {
                Text("Create")
            }
        }
    }
}

#Preview {
    CreatePostView(vm: ViewModel())
}
