import SwiftUI
import PhotosUI

struct SettingsView: View {
    @ObservedObject var vm: ViewModel
    @Binding var tabSelection: Tabs

    
    @State private var showAccountSettingsView = false
    
    //Profile variable states
    @State private var displayName: String
    @State private var bio: String
    
    //Editing states
    @State private var isEditingProfile: Bool = false
    @FocusState private var isFocused: Bool
    
    
    init(vm: ViewModel, tabSelection: Binding<Tabs>) {
        self.vm = vm
        _tabSelection = tabSelection
        self.displayName = vm.current_user?.name ?? "Display Name Unavailable"
        self.bio = vm.current_user?.bio ?? "Bio Unavailable"
    }
    
    
    
    var body: some View {
        VStack{
            HStack {
                Button {
                    tabSelection = .selfProfileView
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15)
                }.padding(.leading, 20)
                Spacer()
                Text("Settings")
                    .font(.title2)
                    .foregroundColor(.ffSecondary)
                Spacer(minLength: 30)
                Button {
                    showAccountSettingsView = true
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                        .font(.system(size: 30))
                }.padding()
                
            }
            ProfilePhotoView(vm: vm, avatarImage: vm.current_user!.profilePicture)
                .frame(width: 150)
            Text("@" + (vm.current_user?.id ?? "USERNAMEERROR"))
                .font(.system(size: 20))
                .foregroundColor(Color.ffSecondary)
                .padding(10)
            Spacer()
            HStack{
                Text("Display name")
                    .font(.system(size:18))
                    .foregroundStyle(Color.ffPrimary)
                    .fontWeight(.bold)
                    .frame(width: 120, alignment: .leading)
                TextField("Enter display name", text: $displayName)
                    .font(.system(size: 18))
                    .foregroundStyle(Color.ffSecondary)
                    .disabled(!isEditingProfile)
            }.padding(.horizontal, 20)
            
            Divider()
                .frame(width: 350, height: 2)
                .overlay(Color.ffTertiary)
            
            HStack{
                Text("Bio")
                    .font(.system(size:18))
                    .foregroundStyle(Color.ffPrimary)
                    .fontWeight(.bold)
                    .frame(width: 120, alignment: .leading)
                TextField("Enter bio", text: $bio)
                    //.lineLimit(5)
                    .font(.system(size: 18))
                    .disabled(!isEditingProfile)
                    .frame(height: 110)
                    .foregroundStyle(Color.ffSecondary)
                    .focused($isFocused)
                    .onSubmit {
                        isFocused = false
                    }
            }.padding(.horizontal, 20)
            
            Divider()
                .frame(width: 350, height: 2)
                .overlay(Color.ffTertiary)
            Spacer()
            if !isEditingProfile {
                Button {
                    isEditingProfile = true
                } label: {
                    Text("Edit")
                        .foregroundStyle(.white)
                        .font(.system(size: 20))
                        .background(RoundedRectangle(cornerRadius: 25.0)
                            .frame(width: 150, height: 40)
                            .foregroundColor(Color.ffSecondary))
                }
            } else {
                HStack {
                    Spacer()
                    Button {
                        displayName = vm.current_user!.name
                        bio = vm.current_user!.bio
                        isEditingProfile = false
                        
                    } label : {
                        Text("Cancel")
                            .foregroundStyle(.white)
                            .font(.system(size: 20))
                            .background(RoundedRectangle(cornerRadius: 25.0)
                                .frame(width: 125, height: 40)
                                .foregroundColor(Color.ffSecondary))
                    }
                    Spacer()
                    Button {
                        vm.updateUserField(field: "name", value: displayName)
                        vm.updateUserField(field: "bio", value: bio)
                        isEditingProfile = false
                    } label: {
                        Text("Save")
                            .foregroundStyle(.white)
                            .font(.system(size: 20))
                            .background(RoundedRectangle(cornerRadius: 25.0)
                                .frame(width: 125, height: 40)
                                .foregroundColor(Color.ffSecondary))
                    }
                    Spacer()
                }
            }
            Spacer()
            
        }.fullScreenCover(isPresented: $showAccountSettingsView) {
            AccountSettingsView(vm: vm, showAccountSettingsView: $showAccountSettingsView)
        }
        
        
    }
}
    
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(vm: ViewModel(), tabSelection: Binding.constant(Tabs.settingsView))
    }
}

struct ProfilePhotoView: View {
    
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: URL?
    
    @State private var isEditingProfilePic: Bool = false
    
    @ObservedObject var vm: ViewModel
    
    init(avatarItem: PhotosPickerItem? = nil, vm: ViewModel, avatarImage: String) {
        self.vm = vm
        self.avatarImage = URL(string: avatarImage)
        print(avatarImage)
    }
    
    var body: some View {
        VStack {
            
            AsyncImage(url: avatarImage) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(.circle)
            } placeholder: {
                ProgressView()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(.circle)
            }
            
            
            
            PhotosPicker("Edit Profile Picture", selection: $avatarItem, matching: .images)

        
        }
        .onChange(of: avatarItem) {
            Task {
                if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        vm.firebase_get_url_from_image(image: uiImage) { image in
                            if let image {
                                vm.updateUserField(field: "profilePicture", value: image.absoluteString)
                                avatarImage = image
                            } else {
                                print("Error uploading new profile picture to firebase")
                            }
                            
                        }
                        return
                    }
                }
                print("Could not load transferable from selected item")
            }
        }
        .onAppear {
            print("avim : \(avatarImage)")
            avatarImage = URL(string: vm.current_user!.profilePicture)
        }
    }
}
    
    
struct AccountSettingsView: View {
    @ObservedObject var vm: ViewModel
    
    @Binding var showAccountSettingsView: Bool
    @State private var phoneNumber: String
    @State private var email: String
    
//    @State private var isEditingPhoneNum: Bool = false
//    @State private var isEditingEmail: Bool = false
    
    init(vm: ViewModel, showAccountSettingsView: Binding<Bool>) {
        self.vm = vm
        _showAccountSettingsView = showAccountSettingsView
        if let user = vm.current_user {
            self.phoneNumber = user.phoneNumber
            self.email = user.email
        } else {
            self.phoneNumber = "Phone Number Unavailable"
            self.email = "Email Unavailable"
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Advanced Settings")
                                    .font(.title)
                                    .foregroundColor(.ffSecondary)
                Spacer().frame(height: 75)
                HStack{
                    Text("Phone Number")
                        .font(.system(size:18))
                        .foregroundStyle(Color.ffPrimary)
                        .fontWeight(.bold)
                        .frame(width: 130, alignment: .leading)
                    TextField("Enter phone number", text: $phoneNumber)
                        .font(.system(size: 18))
                        .foregroundStyle(Color.ffSecondary)
                }.padding(.horizontal, 20)
            }
            
            Divider()
                .frame(width: 350, height: 2)
                .overlay(Color.ffTertiary)
            
            HStack{
                Text("Email")
                    .font(.system(size:18))
                    .foregroundStyle(Color.ffPrimary)
                    .fontWeight(.bold)
                    .frame(width: 130, alignment: .leading)
                TextField("Enter email", text: $email)
                    .font(.system(size: 18))
                    .foregroundStyle(Color.ffSecondary)
            }.padding(.horizontal, 20)
            
            Divider()
                .frame(width: 350, height: 2)
                .overlay(Color.ffTertiary)
            Spacer()
            Button {
                vm.firebase_sign_out()
            } label: {
                Text("Sign Out")
                    .foregroundStyle(.white)
                    .font(.system(size: 20))
                    .background(RoundedRectangle(cornerRadius: 25.0)
                        .frame(width: 150, height: 40)
                        .foregroundColor(.red))
            }.toolbar{
                HStack {
                    Button(action: {
                        showAccountSettingsView = false
                    }, label: {
                        Text("Cancel")
                            .foregroundColor(.gray)
                            .font(.system(size: 15))
                    })
                    .padding(5)
                    Spacer(minLength: 250)
                    Button(action: {
                        if let user = vm.current_user {
                            if (phoneNumber != user.phoneNumber) {
                                vm.updateUserField(field: "phone_number", value: phoneNumber)
                            }
                            if (email != user.email) {
                                vm.updateUserField(field: "email", value: email)
                            }
                        }
                        showAccountSettingsView = false
                    }, label: {
                        Text("Save")
                            .font(.system(size: 15))
                    })
                    .padding(5)
                }
            }
        }
    }
    
}
