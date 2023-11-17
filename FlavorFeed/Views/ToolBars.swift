//
//  ToolBar.swift
//  FlavorFeed
//
//  Created by Jimmy Pham on 9/28/23.
//

import SwiftUI

struct BottomBar: View {
    @Binding var messagesRemaing: Int
    @State private var showCameraViewSheet = false
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color.ffTertiary)
            HStack {
                Button {
                    //rearrange main scroll view
                } label: {
                    Image("table_rows")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28)
                    
                }
                Spacer()
                
                Text("\(messagesRemaing) left")
                    .foregroundStyle(.white)
                    .font(.system(size: 13))
                    .padding([.leading, .trailing], 9)
                    .padding([.top, .bottom], 8)
                    .background(Color.ffSecondary)
                    .clipShape(Capsule())
                
            }.padding()
            Button {
                showCameraViewSheet = true
            } label: {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 57.77, height: 57.77)
                    .foregroundStyle(Color.ffPrimary)
            }
            
        }.fullScreenCover(isPresented: $showCameraViewSheet) {
            CameraView(vm: vm, showCameraViewSheet: $showCameraViewSheet)
        }
    }
}

struct TopBar: View {
    @Binding var tabSelection: Tabs
    var body: some View {
        HStack {
            Button {
                tabSelection = .addFriendsView
            } label: {
                Image("contacts_view_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 29.4)
            }
            
            Spacer()
            Image("flavorfeed_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height:  18.3)
            
            Spacer()
            Button {
                tabSelection = .selfProfileView
            } label: {
                Image("self_profile_view_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 29.4)
            }
        }.padding([.leading, .trailing])
    }
}


