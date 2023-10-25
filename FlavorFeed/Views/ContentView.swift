//
//  ContentView.swift
//  FlavorFeed
//
//  Created by Nicholas Candello on 10/5/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm = ViewModel()
    @AppStorage("log_Status") var logStatus = false
    
    var body: some View {
        if logStatus == true && vm.auth.currentUser != nil {
            LandingPage(vm: vm, tabSelection: .mainScrollView)
        } else {
            NavigationStack {
                LoginView(vm: vm)
            }
        }
    }
}

#Preview {
    ContentView()
}
