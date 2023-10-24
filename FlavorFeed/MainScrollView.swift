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
                TopBar().padding()
                Spacer()
                BottomBar(messagesRemaing: Binding.constant(2)).padding()
            }
            
            ScrollView {
                VStack {
                    Text("Main ScrollView")
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
    MainScrollView(tabSelection: Binding.constant(Tabs.mainScrollView))
}

