//
//  LandingPage.swift
//  FlavorFeed
//
//  Created by Nicholas Candello on 9/12/23.
//

import SwiftUI

enum Tabs {
    case mainScrollView
    case contactsView
    case selfProfileView
<<<<<<< HEAD
    case cameraView
=======
    case addFriendsView
>>>>>>> main
}

struct LandingPage: View {
    @ObservedObject var vm: ViewModel
    @State var tabSelection = Tabs.mainScrollView
    @State var showCamera = false
    
    var body: some View {
        VStack {
            TabView(selection: $tabSelection) {
<<<<<<< HEAD
                ContactsView(tabSelection: $tabSelection)
                    .tag(Tabs.contactsView)
=======
                
                AddFriendsView(tabSelection: $tabSelection, vm: vm).tag(Tabs.addFriendsView)
>>>>>>> main
                
                MainScrollView(vm: vm, tabSelection: $tabSelection, showCamera: $showCamera)
                    .tag(Tabs.mainScrollView)
                
                SelfProfileView(tabSelection: $tabSelection, vm: vm)
                    .tag(Tabs.selfProfileView)
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: self.tabSelection)
            .transition(.slide)
            .fullScreenCover(isPresented: $showCamera) {
                CameraView(camera: CameraModel(), showCamera: $showCamera)
            }
            .edgesIgnoringSafeArea(.bottom)
            
        }.edgesIgnoringSafeArea(.bottom)
    }
}


struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage(vm: ViewModel(), tabSelection: .mainScrollView)
    }
}
