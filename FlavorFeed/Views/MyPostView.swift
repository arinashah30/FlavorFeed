//
//  MyPostView.swift
//  FlavorFeed
//
//  Created by Nicholas Candello on 11/30/23.
//

import Foundation
import SwiftUI

struct MyPostView: View {
    @ObservedObject var vm: ViewModel
    @Binding var showMyPostView: Bool
    @State var post: Post?
    
    var body: some View {
        ScrollView {
            HStack {
                Button {
                    self.showMyPostView.toggle()
                    
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .padding()
                }
                Text("Main Feed")
                    .font(.system(size: 20))
                    .bold()
                Spacer()
            }.foregroundStyle(Color.black)
                .padding()
            PostView(vm: vm, post: post!)
            
        }
    }
}
