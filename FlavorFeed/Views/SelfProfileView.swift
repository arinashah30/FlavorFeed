//
//  SelfProfileView.swift
//  Bereal4Food
//
//  Created by Nicholas Candello on 9/12/23.
//

import SwiftUI

struct SelfProfileView: View {
    @Binding var tabSelection: Tabs
    @ObservedObject var vm: ViewModel
    var body: some View {
        VStack {
            HStack {
                Button {
                    self.tabSelection = .mainScrollView
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .font(.system(size: 40))
                }
                Spacer()
            }.padding()
            Spacer()
            Text("Self Profile View")
            Text(vm.current_user?.id ?? "NO USERNAME FOUND")
            Text(vm.current_user?.name ?? "NO DISPLAY NAME FOUND")
            Button {
                vm.firebase_sign_out()
            } label: {
                Text("Sign Out")
            }

            Spacer()
        }
    }
}
