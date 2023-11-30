//
//  SelfProfileView.swift
//  Bereal4Food
//
//  Created by Nicholas Candello on 9/12/23.
//

import SwiftUI
import MapKit
import Foundation

struct SelfProfileView: View {
    @Binding var tabSelection: Tabs
    @ObservedObject var vm: ViewModel
    @State var showFullCalendar = false
    @State var showFullMap = false

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Button {
                    self.tabSelection = .mainScrollView
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .font(.system(size: 30))
                }
                Spacer()
                Text("Profile")
                    .font(.title2)
                    .foregroundColor(.ffSecondary)
                Spacer()
                
                Button(action: {
                    tabSelection = .settingsView
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                        .font(.system(size: 30))
                })
            }.padding()
            
            ScrollView {
                if let user = vm.current_user {
                    BioView(profilePicture: user.profilePicture, name: user.name, id: user.id, bio: user.bio)
                    PinsView(vm: vm, id: user.id)
                    CalendarView(vm: vm, user: user)
                    
                    Button {
                        showFullCalendar = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 9)
                                .stroke(Color.black, lineWidth: 2)
                                .frame(width: 200, height: 35)
                                .padding()
                            Text("View All My Memories")
                        }

                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, 20)
                    
                    
                    Button(action: {
                        self.showFullMap.toggle()
                    }, label: {
                        MapView(vm: vm, showFullMap: $showFullMap)
                            .frame(minHeight: 400)
                    })
                }
                    }.fullScreenCover(isPresented: $showFullCalendar, content: {
                        FullCalendarView(vm: vm, showFullCalendar: $showFullCalendar)
                    })
                    .fullScreenCover(isPresented: $showFullMap, content: {
                        MapView(vm: vm, showFullMap: $showFullMap)
                    })
                
            }
                    .ignoresSafeArea()
            }
        
}


struct ContentView_Previews: PreviewProvider {
    @State static var tabSelection: Tabs = .selfProfileView
    static var previews: some View {
        SelfProfileView(tabSelection: $tabSelection, vm: ViewModel())
    }
}
