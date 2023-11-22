//
//  CalendarView.swift
//  FlavorFeed
//
//  Created by Rik Roy on 11/16/23.
//

import SwiftUI

struct CalendarView: View {
    
    @ObservedObject var vm: ViewModel
    @State private var calendarItemViews: [CalendarItemView] = []
    let columns = [GridItem(.flexible(), spacing: 1), GridItem(.flexible(), spacing: 1), GridItem(.flexible(), spacing: 1)]

    init(vm: ViewModel) {
        self.vm = vm
        getAllPosts(userID: "arinashah")
        //loadCalendarItemViews()
    }
    
    var body: some View {
        
        
        LazyVGrid(columns: columns, spacing: 1) {
            ForEach((0..<vm.allMyPostDate.count), id:\.self) { index in
                
                CalendarItemView(date: vm.allMyPostDate[index], url: vm.allMyPostUrl[index], postID: "")
                
            }
            
        }
        
        }
        
    
    func loadCalendarItemViews() {
            for num in vm.allMyPosts {
                print(vm.allMyPosts)
                vm.get_day_and_url(postID: num) { day, url in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM-dd-yyyy"
                    print(url)
                    var date = dateFormatter.date(from: day)
                    let calendarItemView = CalendarItemView(date: date ?? Date(), url: url, postID: "")
                    
                    vm.calendarViews.append(calendarItemView)
                }
            }
        }
    
    func getAllPosts(userID: String) {
        vm.getAllPostsOfUser(userID: userID) { postIDs in
            vm.allMyPosts = postIDs
            
            print(vm.allMyPosts)
            
            for post in vm.allMyPosts {
                getPostInfo(postID: post)
            }
        }
    }
    
    func getPostInfo(postID: String) {
        vm.get_day_and_url(postID: postID) { day, url in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let date = dateFormatter.date(from: day)
            
            vm.allMyPostDate.append(date ?? Date())
            vm.allMyPostUrl.append(url)

        }
    }
}

#Preview {
    CalendarView(vm: ViewModel())
}
