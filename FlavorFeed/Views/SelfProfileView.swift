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
                        BioView(profilePicture: user.profilePicture, name: user.name, id: user.id)
                        PinsView(vm: vm, pinIDs: user.pins, id: user.id)
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
                    .buttonStyle(PlainButtonStyle())
                    
                    MapView(restaurants: [CLLocationCoordinate2D(latitude: 43, longitude: 100), CLLocationCoordinate2D(latitude: -10, longitude: 30), CLLocationCoordinate2D(latitude: 20, longitude: -50), CLLocationCoordinate2D(latitude: 17, longitude: -40)])
                        .frame(minHeight: 400)
                    
                }.fullScreenCover(isPresented: $showFullCalendar, content: {
                    FullCalendarView(vm: vm, showFullCalendar: $showFullCalendar)
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
