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
    var dates: [Date] = []
    let columns = [GridItem(.flexible(), spacing: 3), GridItem(.flexible(), spacing: 3), GridItem(.flexible(), spacing: 3)]
    var count: Int = 0

    init(vm: ViewModel) {
        self.vm = vm
        getAllPosts(userID: "arinashah")
        
        for num in -19...0 {
            self.dates.append(getNDaysFromNow(days: num))
        }
        
        print(self.dates)
    }
    
    var body: some View {
        
        /*LazyVGrid(columns: columns, spacing: 1) {
            ForEach((0..<vm.allMyPostDate.count), id:\.self) { index in
                
                CalendarItemView(date: vm.allMyPostDate[index], url: vm.allMyPostUrl[index], postID: "")
                
            }
            
        }*/
//        LazyVGrid(columns: columns, spacing: 1) {
//            ForEach((0..<vm.allMyPostDate.count), id:\.self) { index in
//                
//                CalendarItemView(date: vm.allMyPostDate[index], url: vm.allMyPostUrl[index], postID: "")
//                
//            }
//            
//        }
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(dates, id:\.self) { index in
                    CalendarItemView(date: index, url: "", postID: "", vm: vm)
                }
            }
        }
    }
    
    func getAllPosts(userID: String) {
        vm.getAllPostsOfUser(userID: userID) { postIDs in
            vm.allMyPosts = postIDs
            
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
    
    func getNDaysFromNow(days: Int) -> Date {
        return Date(timeIntervalSinceNow: TimeInterval(days*24*3600))
    }
}

#Preview {
    CalendarView(vm: ViewModel())
}
