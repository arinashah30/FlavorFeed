import SwiftUI


struct UserListView: View {
    @ObservedObject var vm: ViewModel
    @Binding var suggestions: [Friend]
    @Binding var friends: [Friend]
    @Binding var requests: [Friend]
    @Binding var searchText: String
    @Binding var selectedOption: String
    
    @State var filteredUsers = [Friend]()
    @State var showFriendProfile: Bool = false
    @State var friend: Friend?
    
    
    var body: some View {
        GeometryReader { geometry in
            List {
                ForEach(self.filteredUsers, id: \.self) { user in
                        UserRow(user: user, width: geometry.size.width, vm: vm, selectedOption: $selectedOption, onAccept: {_ in self.accept(user)}, onReject: {_ in self.reject(user)}, onSend: { _ in self.send(user)})
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            friend = user
                            print("BRUH: \($friend.wrappedValue)")
                            if (friend != nil) {
                                showFriendProfile = true
                            }
                        }

                    
                }
            }.refreshable {
                refresh(selectedOption)
            }
            .onChange(of: searchText) {
                if selectedOption == "Suggestions" {
                    search()
                }
            }
            .onChange(of: selectedOption) { newValue in
                refresh(newValue)
            }
            .listStyle(.plain)
            .fullScreenCover(isPresented: $showFriendProfile, content: {
                FriendProfileView(vm: vm, friend: $friend, showFriendProfile: $showFriendProfile)
            })
        }
    }
    func accept(_ user: Friend) {
        vm.accept_friend_request(from: user.id, to: vm.current_user!.id)
        refresh("")
    }
    func reject(_ user: Friend) {
        vm.reject_friend_request(from: user.id, to: vm.current_user!.id)
        refresh("")
    }
    
    func send(_ user: Friend) {
        vm.send_friend_request(from: vm.current_user!.id, to: user.id)
        refresh("")
    }
    
    func refresh(_ newValue: String) {
        if newValue == "Requests" {
            vm.get_friend_requests() { friends in
                requests = friends
            }
        } else if newValue == "Suggestions" {
            vm.get_friend_suggestions() { friends in
                suggestions = friends
            }
        } else if newValue == "Friends" {
                vm.get_friends_ids() { friendIDs in
                    vm.get_friends(userIDs: friendIDs) { friend in
                        friends = friend
                    }
                }
            }
        
        let optionMap = ["Suggestions": suggestions, "Requests": requests, "Friends": friends]
        var selectedList: [Friend] = optionMap[selectedOption]!
        
        if searchText.isEmpty || selectedOption == "Suggestions" {
            self.filteredUsers = selectedList
        } else {
            self.filteredUsers = selectedList.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        filteredUsers.removeAll(where: { friend in
            friend.id == vm.current_user!.id
        })
    }
    
    func search() {
        DispatchQueue.main.async {
            if searchText.count > 0 {
                vm.firebase_search_for_friends(username: searchText) { friends in
                    self.suggestions = friends
                    refresh("Suggestions")
                }
            }
        }
    }
    
}

struct UserRow: View {
    let user: Friend
    let width: CGFloat
    @ObservedObject var vm: ViewModel
    @Binding var selectedOption: String
    var onAccept: (Friend) -> Void
    var onReject: (Friend) -> Void
    var onSend: (Friend) -> Void
    
    
    
    var body: some View {
        HStack {

            vm.imageLoader.img(url: URL(string: user.profilePicture) ?? URL(string: "https://static-00.iconduck.com/assets.00/person-crop-circle-icon-256x256-02mzjh1k.png")!) { image in
                image.resizable()
            }.scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
            

            VStack(alignment: .leading) {
                Text(user.name).bold()
                Text(user.id)
            }
            Spacer()
            if (selectedOption != "Friends") {
                Button(action: {
                    if selectedOption == "Suggestions" {
                        onSend(user)
                    } else if selectedOption == "Requests" {
                        onAccept(user)
                    }
                }) {
                    Text(selectedOption == "Suggestions" ? "REQUEST" : "ACCEPT")
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
