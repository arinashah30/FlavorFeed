import SwiftUI

struct UserListView: View {
    var user: User
    let icon= "Image"
    var body: some View{
        VStack{
            HStack{
                Image(icon)
                    .resizable()
                    .frame(width: 50, height: 50)
                Text(user.name)
                Spacer()
            } .border(Color.gray)
            HStack{
                Image(icon)
                    .resizable()
                    .frame(width: 50, height: 50)
                Text(user.name)
                Spacer()
            }.border(Color.gray)
            HStack{
                Image(icon)
                    .resizable()
                    .frame(width: 50, height: 50)
                Text(user.name)
                Spacer()
            }.border(Color.gray)
        }
        //Text(/@START_MENU_TOKEN@/"Hello, World!"/@END_MENU_TOKEN@/)
    }
}

struct UserList_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: UUID(), name: "Triem", username: "", password: "", profilePicture: "", email: "", favorites: [], friends: [], savedPosts: [], bio: "", myPosts: [], phoneNumber: 0, location: "", myRecipes: [])
        UserListView(user: user)
    }
}
