import SwiftUI

struct UserListView: View {
    var user: User
    let icon = "Image"
    var body: some View {
        VStack{
            HStack{
                Image(icon)
                    .resizable()
                    .frame(width: 80, height: 70)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(user.name).bold()
                    Text(user.username)
                }
                Spacer()
                Button(action: {})
                {
                    Text("ADD")
                        .font(.system(size: 16))
                        .bold()
                        .foregroundColor(.white)
                }
                    .buttonStyle(.bordered)
                    .background(Color(.darkGray))
                    .cornerRadius(25)
                Button(action: {})
                {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 13, height: 13)
                        .foregroundColor(.gray)
                        .bold()
                }
                    .padding([.trailing], 30)
                    .padding([.leading], 10)
            }
            HStack{
                Image(icon)
                    .resizable()
                    .frame(width: 80, height: 70)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(user.name).bold()
                    Text(user.username)
                }
                Spacer()
                Button(action: {})
                {
                    Text("ADD")
                        .font(.system(size: 16))
                        .bold()
                        .foregroundColor(.white)
                }
                    .buttonStyle(.bordered)
                    .background(Color(.darkGray))
                    .cornerRadius(25)
                Button(action: {})
                {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 13, height: 13)
                        .foregroundColor(.gray)
                        .bold()
                }
                    .padding([.trailing], 30)
                    .padding([.leading], 10)
            }
            HStack{
                Image(icon)
                    .resizable()
                    .frame(width: 80, height: 70)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(user.name).bold()
                    Text(user.username)
                }
                Spacer()
                Button(action: {})
                {
                    Text("ADD")
                        .font(.system(size: 16))
                        .bold()
                        .foregroundColor(.white)
                }
                    .buttonStyle(.bordered)
                    .background(Color(.darkGray))
                    .cornerRadius(25)
                Button(action: {})
                {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 13, height: 13)
                        .foregroundColor(.gray)
                        .bold()
                }
                    .padding([.trailing], 30)
                    .padding([.leading], 10)
            }
            HStack{
                Image(icon)
                    .resizable()
                    .frame(width: 80, height: 70)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(user.name).bold()
                    Text(user.username)
                }
                Spacer()
                Button(action: {})
                {
                    Text("ADD")
                        .font(.system(size: 16))
                        .bold()
                        .foregroundColor(.white)
                }
                    .buttonStyle(.bordered)
                    .background(Color(.darkGray))
                    .cornerRadius(25)
                Button(action: {})
                {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 13, height: 13)
                        .foregroundColor(.gray)
                        .bold()
                }
                    .padding([.trailing], 30)
                    .padding([.leading], 10)
            }
            HStack{
                Image(icon)
                    .resizable()
                    .frame(width: 80, height: 70)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(user.name).bold()
                    Text(user.username)
                }
                Spacer()
                Button(action: {})
                {
                    Text("ADD")
                        .font(.system(size: 16))
                        .bold()
                        .foregroundColor(.white)
                }
                    .buttonStyle(.bordered)
                    .background(Color(.darkGray))
                    .cornerRadius(25)
                Button(action: {})
                {
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
        //Text(/@START_MENU_TOKEN@/"Hello, World!"/@END_MENU_TOKEN@/)
    }
}

struct UserList_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: UUID(), name: "Triem", username: "triem123", password: "", profilePicture: "", email: "", favorites: [], friends: [], savedPosts: [], bio: "", myPosts: [], phoneNumber: 0, location: "", myRecipes: [])
        UserListView(user: user)
    }
}
