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
    case addFriendsView
}

struct LandingPage: View {
    @ObservedObject var vm: ViewModel
    @State var tabSelection: Tabs
    
    var body: some View {
        VStack {
            TabView(selection: $tabSelection) {
                
                //ContactsView(tabSelection: $tabSelection).tag(Tabs.contactsView)
                
                AddFriendsView(tabSelection: $tabSelection).tag(Tabs.addFriendsView)
                
                MainScrollView(vm: vm, tabSelection: $tabSelection)
                    .tag(Tabs.mainScrollView)
                
                SelfProfileView(tabSelection: $tabSelection)
                    .tag(Tabs.selfProfileView)
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: self.tabSelection)
            .transition(.slide)
            
        }.edgesIgnoringSafeArea(.bottom)
    }
}


struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage(vm: ViewModel(), tabSelection: .mainScrollView)
    }
}
