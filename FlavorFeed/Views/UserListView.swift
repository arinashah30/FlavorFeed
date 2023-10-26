import SwiftUI

struct UserListView: View {
    var body: some View {
        var users: [User] = []

        for _ in 1...30 {
            let user = User(id: "name1", name: "name1", username: "userName1", profilePicture: "", email: "", favorites: [], friends: [], savedPosts: [], bio: "", myPosts: [], phoneNumber: 0, location: "", myRecipes: [])
            users.append(user)
        }

        return ScrollView {
            VStack {
                ForEach(users, id: \.id) { user in
                    UserRow(user: user)
                }
            }
        }
        .frame(maxHeight: .infinity)
    }

    struct UserRow: View {
        let icon = "Image"
        let user: User

        var body: some View {
            HStack {
                //Image(icon)
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 70)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(user.name).bold()
                    Text(user.username)
                }
                Spacer()
                Button(action: {}) {
                    Text("ADD")
                        .font(.system(size: 16))
                        .bold()
                        .foregroundColor(.white)
                }
                .buttonStyle(.bordered)
                .background(Color.ffPrimary)
                .cornerRadius(25)
                Button(action: {}) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 13, height: 13)
                        .foregroundColor(.gray)
                        .bold()
                }
                .padding([.trailing], 30)
                .padding([.leading], 10)
            }
        }
    }
}

struct UserList_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
