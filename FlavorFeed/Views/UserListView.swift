import SwiftUI

struct UserListView: View {
    var users: [User]
    @Binding var searchText: String
    
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            List {
                ForEach(filteredUsers) { user in
                    UserRow(user: user, width: geometry.size.width).padding(5)
                }//.listRowBackground(Color.ffPrimary)
            }.scrollContentBackground(.hidden)
                .edgesIgnoringSafeArea(.horizontal)
        }
    }
}

struct UserRow: View {
    let user: User
    let width: CGFloat
    var body: some View {
        HStack {
            Image(user.profilePicture)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 85, height: 70)
            
            VStack(alignment: .leading) {
                Text(user.name).bold()
                Text(user.username)
            }
            Spacer()
            Button(action: {
                //add friend function
            }) {
                Text("ADD")
                    .font(.system(size: 16))
                    .bold()
                    .foregroundColor(.white)
            }
            .buttonStyle(.bordered)
            .background(Color.ffPrimary)
            .cornerRadius(25)
            Button(action: {
                
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 13, height: 13)
                    .foregroundColor(.gray)
                    .bold()
            }
            .padding(.horizontal, 10)
        }.frame(width: width - 25)
        
    }
}

#Preview{
    UserListView(users: [User(id: "name1", name: "name1", username: "userName1", profilePicture: "self_profile_view_icon", email: "", favorites: [], friends: [], savedPosts: [], bio: "", myPosts: [], phoneNumber: 0, location: "", myRecipes: []), User(id: "name1", name: "name1", username: "userName1", profilePicture: "self_profile_view_icon", email: "", favorites: [], friends: [], savedPosts: [], bio: "", myPosts: [], phoneNumber: 0, location: "", myRecipes: []), User(id: "name1", name: "name1", username: "userName1", profilePicture: "self_profile_view_icon", email: "", favorites: [], friends: [], savedPosts: [], bio: "", myPosts: [], phoneNumber: 0, location: "", myRecipes: [])], searchText: Binding.constant(""))
}
