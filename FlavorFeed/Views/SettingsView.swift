import SwiftUI
import PhotosUI

struct SettingsView: View {
    @ObservedObject var vm: ViewModel
    
    @Binding var showSettingsView: Bool
    
    @State private var showAccountSettingsView = false
    
    //Profile variable states
    @State private var displayName: String
    @State private var bio: String
    
    //Editing states
    @State private var isEditingProfile: Bool = false
    
    init(vm: ViewModel, showSettings: Binding<Bool>, displayName: String, bio: String) {
        self.vm = vm
        _showSettingsView = showSettings
        self.displayName = vm.current_user!.name
        self.bio = vm.current_user!.bio
    }
    
    
    var body: some View {
        
        VStack{
            HStack {
                Spacer()
                Button {
                    showSettingsView.toggle()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15)
                }.padding(.trailing, 30)
                Text("Profile Settings")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .padding(.trailing, 50)
                Spacer()
                
            }
            ProfilePhotoView(vm: vm)
                .frame(width: 150)
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
                TextField("Enter bio", text: $bio, axis: .vertical)
                    .lineLimit(5)
                    .font(.system(size: 18))
                    .disabled(!isEditingProfile)
                    .frame(height: 110)
                    .foregroundStyle(Color.ffSecondary)
            }.padding(.horizontal, 20)
            
            Divider()
                .frame(width: 350, height: 2)
                .overlay(Color.ffTertiary)
            Spacer()
            if !isEditingProfile {
                Button {
                    isEditingProfile.toggle()
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
                        isEditingProfile.toggle()
                        
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
                        isEditingProfile.toggle()
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
            Button{
                showAccountSettingsView.toggle()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10.0)
                        .frame(width: 325, height: 50)
                        .foregroundColor(Color.ffTertiary)
                    HStack {
                        Text("Account Settings")
                            .foregroundStyle(Color.black)
                            .font(.system(size: 20))
                        Spacer()
                        Image(systemName: "chevron.right")
                    }.padding(.horizontal, 55)
                }
            }
            Spacer()
            
        }.fullScreenCover(isPresented: $showAccountSettingsView) {
            AccountSettingsView(vm: vm, phoneNumber: vm.current_user!.phoneNumber, email: vm.current_user!.email, showAccountSettings: $showAccountSettingsView)
        }
        
    }
}
    
//struct SettingsView_Previews: PreviewProvider {
//    static let vm = ViewModel(user: User(id: "username", name: "Display Name", profilePicture: "samplepfp", email: "samplemail@mail.com", bio: "Sample bio", phoneNumber: "000-111-2244", friends: [], pins: [], myPosts: []))
//    static var previews: some View {
//        SettingsView(vm: vm, showSettings: Binding.constant(true), displayName: vm.current_user!.name, bio: vm.current_user!.bio)
//    }
//}

struct ProfilePhotoView: View {
    
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    
    @State private var isEditingProfilePic: Bool = false
    
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        VStack {
            if let avatarImage {
                avatarImage
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle")
                    .font(.system(size: 120))
            }
            
            
            PhotosPicker("Edit picture", selection: $avatarItem, matching: .images)

        
        }
        .onChange(of: avatarItem) { _ in
            Task {
                if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        avatarImage = Image(uiImage: uiImage)
                        vm.new_profile_image = avatarImage
                        return
                    }
                }

                print("Failed")
            }
        }
    }
}
    
    
struct AccountSettingsView: View {
    @ObservedObject var vm: ViewModel
    
    @Binding var showAccountSettingsView: Bool
    
    @State private var phoneNumber: String
    @State private var email: String
    
    @State private var isEditingPhoneNum: Bool = false
    @State private var isEditingEmail: Bool = false
    
    init(vm: ViewModel, phoneNumber: String, email: String, showAccountSettings: Binding<Bool>) {
        self.vm = vm
        _showAccountSettingsView = showAccountSettings
        self.phoneNumber = vm.current_user!.phoneNumber
        self.email = vm.current_user!.email
    }
    var body: some View {
        VStack{
            HStack {
                Spacer()
                Button {
                    showAccountSettingsView.toggle()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15)
                }.padding(.trailing, 25)
                Text("Account Settings")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .padding(.trailing, 40)
                Spacer()
                
            }
                .font(.system(size: 30))
                .fontWeight(.bold)

            VStack {
                HStack{
                    Text("Phone Number")
                        .font(.system(size:18))
                        .foregroundStyle(Color.ffPrimary)
                        .fontWeight(.bold)
                        .frame(width: 130, alignment: .leading)
                    TextField("Enter phone number", text: $phoneNumber)
                        .font(.system(size: 18))
                        .foregroundStyle(Color.ffSecondary)
                        .disabled(!isEditingPhoneNum)
                }.padding(.horizontal, 20)
                if !isEditingPhoneNum {
                    Button {
                        isEditingPhoneNum.toggle()
                    } label: {
                        Text("Edit")
                            .foregroundStyle(.white)
                            .font(.system(size: 20))
                            .background(RoundedRectangle(cornerRadius: 25.0)
                                .frame(width: 150, height: 40)
                                .foregroundColor(Color.ffSecondary))
                    }.padding()
                } else {
                    HStack {
                        Spacer()
                        Button {
                            phoneNumber = vm.current_user!.phoneNumber
                            isEditingPhoneNum.toggle()
                            
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
                            vm.updateUserField(field: "phone_number", value: phoneNumber)
                            isEditingPhoneNum.toggle()
                        } label: {
                            Text("Save")
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                                .background(RoundedRectangle(cornerRadius: 25.0)
                                    .frame(width: 125, height: 40)
                                    .foregroundColor(Color.ffSecondary))
                        }
                        Spacer()
                    }.padding()
                }
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
                TextField("Enter bio", text: $email)
                    .font(.system(size: 18))
                    .disabled(!isEditingEmail)
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
                        .foregroundColor(Color.ffSecondary))
            }
            Spacer()
        }
    }
    
}
    
//struct AccountSettingsView_Previews: PreviewProvider {
//    static let vm = ViewModel(user: User(id: "username", name: "Display Name", profilePicture: "samplepfp", email: "samplemail@mail.com", bio: "Sample bio", phoneNumber: "000-111-2244", friends: [], pins: [], myPosts: []))
//    static var previews: some View {
//        AccountSettingsView(vm: vm, phoneNumber: vm.current_user!.phoneNumber, email: vm.current_user!.email, showAccountSettings: Binding.constant(true))
//    }
//}
