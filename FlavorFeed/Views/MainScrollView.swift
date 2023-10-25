//
//  MainScrollView.swift
//  Bereal4Food
//
//  Created by Nicholas Candello on 9/15/23.
//

import SwiftUI

struct MainScrollView: View {
    @ObservedObject var vm: ViewModel
    @Binding var tabSelection: Tabs

    var body: some View {
        ZStack {
            VStack {
                TopBar(tabSelection: $tabSelection)
                Spacer()
                BottomBar(messagesRemaing: Binding.constant(2))
                    .frame(height: 120)
                    .cornerRadius(10)
            }.edgesIgnoringSafeArea(.bottom)
            
            ScrollView {
                Spacer().frame(height: 40)
                VStack {
                    Text("Welcome, \(vm.current_user?.name ?? "")!").font(.title)
                    Button {
                        vm.firebase_sign_out()
                    } label: {
                        Text("Sign Out")
                    }

                }
            }
            
        }
    }
}

#Preview {
    MainScrollView(vm: ViewModel(), tabSelection: Binding.constant(Tabs.mainScrollView))
}

