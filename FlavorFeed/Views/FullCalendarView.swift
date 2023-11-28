//
//  CalendarView.swift
//  FlavorFeed
//
//  Created by Rik Roy on 11/16/23.
//

import SwiftUI

struct FullCalendarView: View {
    
    @ObservedObject var vm: ViewModel
    @State private var calendarItemViews: [CalendarItemView] = []
    var dates: [Date] = []
    let columnWidth: CGFloat = UIScreen.main.bounds.size.width / 3
    let columns: [GridItem]
    var count: Int = 0

    init(vm: ViewModel) {
        self.vm = vm
        columns = [GridItem(.fixed(columnWidth), spacing: 3), GridItem(.fixed(columnWidth), spacing: 3), GridItem(.fixed(columnWidth), spacing: 3)]
        
        for daysAgo in 0..<30 {
            dates.append(getNDaysFromNow(days: -1 * daysAgo))
        }
        
        print("INIT FINISH")
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(dates, id:\.self) { index in
                    ZStack {
                        CalendarItemView(date: index, vm: vm)
                            .frame(width: columnWidth, height: columnWidth)
                            .clipped()
                        HStack {
                            VStack {
                                Text(getDayOfWeek(date: index))
                                    .font(.system(size: 15))
                                    .foregroundStyle(Color.white)
                                    .padding(.top, 5)
                                    .padding(.leading, 5)
                                Text(getDay(date: index))
                                    .font(.system(size: 20))
                                    .padding(.leading, 10)
                                    .bold()
                                    .foregroundStyle(Color.white)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    func getNDaysFromNow(days: Int) -> Date {
        return Date(timeIntervalSinceNow: TimeInterval(days*24*3600))
    }
    
    
    func getDayOfWeek(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: date)
    }
    
    func getDay(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    FullCalendarView(vm: ViewModel())
}
