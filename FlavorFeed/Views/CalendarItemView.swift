//
//  CalendarItemView.swift
//  FlavorFeed
//
//  Created by Rik Roy on 11/16/23.
//

import SwiftUI

struct CalendarItemView: View {
    var url: String
    var date: Date
    var postID: String
    //var vm: ViewModel
    
    init(date: Date, url: String, postID: String) {
        self.date = date
        self.url = url
        self.postID = postID
    }
    
    var body: some View {
        ZStack(alignment: .topLeading){
            
            AsyncImage(
                url: URL(string: url) ?? URL(string: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAMFBMVEWpqammpqbT09PX19fc3Nzi4uLm5uajo6Py8vLQ0NDd3d3+/v76+vrx8fHt7e3k5OQpkTr2AAABZ0lEQVR4nO3dQWrCABRF0URNorbV/e+2UmihOKgURE5yzwrenX/4w9v78eNyuczzfJ1uDt/2v+z+b/+nwyPO0wOu853jcF1+jL7lzmmYlmHNxt0wja8e8VSbKDyvvvBQoa1CX4W+Cn0V+ir03Qr3Fdoq9FXoq9BXoa9CX4W+Cn0V+ir0Veir0Fehr0Jfhb4KfZso3FVoq9BXoa9CX4W+Cn0V+ir0Veir0Fehr0Jfhb4KfRX6KvRV6KvQV6GvQt8mLoYqxFXoq9BXoa9CX4W+Cn0V+ir0Veir0Fehr0Jfhb4KfRX6KvRV6KvQV6FvE19YKsRV6KvQV6GvQl+Fvgp9Ffoq9FXoq9BXoa9CX4W+Cn0V+ir0baLwvPrCqUJbhb4KfRX6KvRV6KvQV6GvQl+Fvgp9Ffoq9FXoq9BXoa9CX4W+TRTOy6tHPFWFvgp9Ffoq9FXoq9BXoa9C31fhuGbLaTiedmt2mj8BNIYPDiZn2y8AAAAASUVORK5CYII="),
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                         .frame(maxWidth: 200, maxHeight: 300)
                },
                placeholder: {
                    ProgressView()
                }
            )
            VStack {
                Text(getDayOfWeek(date: date))
                    .font(.system(size: 15))
                    .foregroundStyle(Color.white)
                    .padding(.top, 5)
                    .padding(.leading, 5)
                Text(getDay(date: date))
                    .font(.system(size: 20))
                    .padding(.leading, 10)
                    .bold()
                    .foregroundStyle(Color.white)
        
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
    CalendarItemView(date: Date(), url: "", postID: "")
}
