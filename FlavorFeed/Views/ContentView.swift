//
//  ContentView.swift
//  FlavorFeed
//
//  Created by Nicholas Candello on 10/5/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm: ViewModel
    @AppStorage("log_Status") var logStatus = false
    @Binding var isActive: Bool
    
    init(isActive: Binding<Bool>) {
        self.vm = ViewModel(isActive: isActive)
        self._isActive = isActive
    }
    
    var body: some View {
        if logStatus == true && vm.auth.currentUser != nil {
            LandingPage(vm: vm, tabSelection: .mainScrollView)
                .edgesIgnoringSafeArea(.bottom)
        } else {
            NavigationStack {
                LoginView(vm: vm).onAppear {
                    isActive = true
                }
            }
        }
    }
    
}

#Preview {
    ContentView(isActive: Binding.constant(true))
}
