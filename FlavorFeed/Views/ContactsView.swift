//
//  ContactsView.swift
//  Bereal4Food
//
//  Created by Nicholas Candello on 9/12/23.
//

import SwiftUI

struct ContactsView: View {
    @Binding var tabSelection: Tabs
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    self.tabSelection = .mainScrollView
                } label: {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.black)
                        .font(.system(size: 40))
                }
            }.padding()
            Spacer()
            Text("Contacts View")
            Spacer()
        }
    }
}

