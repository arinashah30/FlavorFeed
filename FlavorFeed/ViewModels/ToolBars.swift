//
//  ToolBar.swift
//  FlavorFeed
//
//  Created by Jimmy Pham on 9/28/23.
//

import SwiftUI

struct BottomBar: View {
    @Binding var messagesRemaing: Int
    

    var body: some View {
        ZStack {
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "square.grid.2x2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25)
                }
                
                
                Spacer()
                
                Text("\(messagesRemaing) left")
                    .foregroundStyle(.blue)
                    .padding(3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8.0)
                            .stroke(Color.blue, lineWidth: 2.5)
                      )
            }
            
            Button {
                
            } label: {
                Image(systemName: "circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
            }
            .frame(maxWidth: .infinity)

        }
    }
}

struct TopBar: View {
    @Binding var tabSelection: Tabs
    var body: some View {
        HStack {
            Button {
                tabSelection = .contactsView
            } label: {
                Image(systemName: "person.3")
                    .frame(width: 25)
            }
            
            
            Text("FlavorFeed")
                .frame(maxWidth: .infinity)
            
            
            Button {
                tabSelection = .selfProfileView
            } label: {
                Image(systemName: "person.crop.circle")
                    .frame(width: 25)
            }
        }
    }
}
