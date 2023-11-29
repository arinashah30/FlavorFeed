//
//  LandingPage.swift
//  FlavorFeed
//
//  Created by Nicholas Candello on 9/12/23.
//

import SwiftUI

enum Tabs {
    case mainScrollView
    case selfProfileView
    case addFriendsView
    case settingsView
}

struct LandingPage: View {
    @ObservedObject var vm: ViewModel
    @State var tabSelection: Tabs
    
    var body: some View {
        VStack {
            TabView(selection: $tabSelection) {
                
                AddFriendsView(tabSelection: $tabSelection, vm: vm).tag(Tabs.addFriendsView)
                
                MainScrollView(vm: vm, tabSelection: $tabSelection)
                    .tag(Tabs.mainScrollView)
                
                SelfProfileView(tabSelection: $tabSelection, vm: vm)
                    .tag(Tabs.selfProfileView)
                
                SettingsView(vm: vm, tabSelection: $tabSelection)
                    .tag(Tabs.settingsView)
                
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
