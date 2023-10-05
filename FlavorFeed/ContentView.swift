//
//  ContentView.swift
//  FlavorFeed
//
//  Created by Nicholas Candello on 10/5/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm = ViewModel()
    @AppStorage("log_Status") var log_Status = false
    
    var body: some View {
        if(log_Status) {
            LandingPage(vm: vm)
        } else {
            Onboarding(vm: vm)
        }
    }
}

#Preview {
    ContentView()
}
