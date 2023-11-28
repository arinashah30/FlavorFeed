import SwiftUI


struct UserListView: View {
    @ObservedObject var vm: ViewModel
    @Binding var suggestions: [Friend]
    @Binding var friends: [Friend]
    @Binding var requests: [Friend]
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
                        NavigationLink(destination: FriendProfileView(vm: vm, friend: user), label: {
                            UserRow(suggestions: suggestions, friends: friends, requests: requests, user: user, width: geometry.size.width, vm: vm, selectedOption: $selectedOption, onAccept: {_ in self.accept(user)}, onReject: {_ in self.reject(user)}).padding(.horizontal, 10)
                        })
                        
                    }//.listRowBackground(Color.ffPrimary)
                }//.scrollContentBackground(.hidden)
                    .listStyle(.plain)
            }
        }
    func accept(_ user: Friend) {
        friends.append(user)
        requests.removeAll { request in
            request.id == user.id
        }
        if (selectedOption == "Requests") {
            vm.accept_friend_request(from: user.id, to: vm.current_user!.id)
        } else if (selectedOption == "Suggestions") {
            vm.send_friend_request(from: vm.current_user!.id, to: user.id)
        }
    }
    func reject(_ user: Friend) {
        requests.removeAll { request in
            request.id == user.id
        }
        vm.reject_friend_request(from: user.id, to: vm.current_user!.id)
    }
    
    
}

struct UserRow: View {
    var suggestions: [Friend]
    var friends: [Friend]
    var requests: [Friend]
    let user: Friend
    let width: CGFloat
    @ObservedObject var vm: ViewModel
    @Binding var selectedOption: String
    var onAccept: (Friend) -> Void
    var onReject: (Friend) -> Void
    
    
    
    var body: some View {
        HStack {
            
            if let image = vm.load_image_from_url(url: user.profilePicture) {
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 70, height: 70)
            } else {
                Color.gray
                    .clipShape(Circle())
                    .frame(width: 70, height: 70)
            }
                
            VStack(alignment: .leading) {
                Text(user.name).bold()
                Text(user.id)
            }
            Spacer()
            if (selectedOption != "Friends") {
                Button(action: {
                    onAccept(user)
                }) {
                    Text("ADD")
                        .font(.system(size: 16))
                        .bold()
                        .foregroundColor(.white)
                }
                .buttonStyle(.bordered)
                .background(Color.ffPrimary)
                .cornerRadius(25)
                if (selectedOption == "Requests") {
                    Button(action: {
                        onReject(user)
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 13, height: 13)
                            .foregroundColor(.gray)
                            .bold()
                    }
                    .padding(.horizontal, 10)
                    .buttonStyle(.borderless)
                }
            }
        }.frame(width: width - 25)
        
    }
}
