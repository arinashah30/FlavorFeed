import SwiftUI


struct UserListView: View {    
    @ObservedObject var vm: ViewModel
    var suggestions: [Friend]
    var friends: [Friend]
    var requests: [Friend]
    @Binding var searchText: String
    @Binding var selectedOption: String
    
    var filteredUsers: [Friend] {
        let optionMap = ["Suggestions": suggestions, "Requests": requests, "Friends": friends]
        let selectedList: [Friend] = optionMap[selectedOption]!
        
        if searchText.isEmpty {
            return selectedList
        } else {
            return selectedList.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
            GeometryReader { geometry in
                List {
                    ForEach(filteredUsers) { user in
                        UserRow(user: user, width: geometry.size.width, vm: vm).padding(.horizontal, 10)
                    }//.listRowBackground(Color.ffPrimary)
                }//.scrollContentBackground(.hidden)
                    .listStyle(.plain)
            }
        }
}

struct UserRow: View {
    let user: Friend
    let width: CGFloat
    @ObservedObject var vm: ViewModel
    var body: some View {
        HStack {
            vm.load_image_from_url(url: user.profilePicture)!
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 85, height: 70)
            VStack(alignment: .leading) {
                Text(user.name).bold()
                Text(user.id)
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
