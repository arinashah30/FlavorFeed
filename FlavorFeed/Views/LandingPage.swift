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
}

struct LandingPage: View {
    @ObservedObject var vm: ViewModel
    @State var tabSelection: Tabs = .mainScrollView
    
    var body: some View {
        ZStack {
            TabView(selection: $tabSelection) {
                
                ContactsView(tabSelection: $tabSelection)
                    .tag(Tabs.contactsView)
                
                MainScrollView(vm: vm, tabSelection: $tabSelection)
                    .tag(Tabs.mainScrollView)
                
                SelfProfileView(tabSelection: $tabSelection)
                    .tag(Tabs.selfProfileView)
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: self.tabSelection)
            .transition(.slide)
            
        }
    }
}


struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage(vm: ViewModel())
    }
}
