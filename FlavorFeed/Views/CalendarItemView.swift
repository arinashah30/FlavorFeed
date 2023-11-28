//
//  CalendarItemView.swift
//  FlavorFeed
//
//  Created by Rik Roy on 11/16/23.
//

import SwiftUI

struct CalendarItemView: View {
    var date: Date
    var vm: ViewModel
    @State var url = "https://imageio.forbes.com/specials-images/imageserve/5ed6636cdd5d320006caf841/0x0.jpg?format=jpg&height=900&width=1600&fit=bounds" // black square
    
    
    init(date: Date, vm: ViewModel) {
        self.date = date
        self.vm = vm
    }
    var body: some View {
        ZStack(alignment: .topLeading){
            
            AsyncImage(
                url: URL(string: url),
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxHeight: 200)
                },
                placeholder: {
                    ProgressView()
                }
            )
            
        }.onAppear() {
            DispatchQueue.main.async {
                vm.get_post_from_day(day: getDayformatted(date: date)) { postID in
                    if postID.count > 0 {
                        print(getDayformatted(date: date))
                        vm.firebase_get_post(postID: postID) { post in
                            self.url = post.images[0][0]
                            print("Showing image for \(getDayformatted(date: date)): \(post.images[0][0])")
                        }
                    }
                }
            }
        }
    }
    func getDayformatted(date: Date) -> String {
        return vm.dayFormatter.string(from: date)
    }

}

#Preview {
    CalendarItemView(date: Date(), vm: ViewModel())
}
