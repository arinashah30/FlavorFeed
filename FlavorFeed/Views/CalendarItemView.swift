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
    let frame: CGFloat
    @State var post_id: String?
    @State var url = "https://imageio.forbes.com/specials-images/imageserve/5ed6636cdd5d320006caf841/0x0.jpg?format=jpg&height=900&width=1600&fit=bounds" // black square
    
    
    init(date: Date, vm: ViewModel, frame: CGFloat) {
        self.date = date
        self.vm = vm
        self.frame = frame
        print("drawing calendar item")
    }
    var body: some View {
        ZStack(alignment: .topLeading){
            
            vm.imageLoader.img(url: URL(string: url)!) { image in
                image.resizable()
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: frame, height: frame)
            .clipped()
            
            if post_id != nil {
                HStack {
                    Spacer()
                    Button(action: {
                        // pin toggle
                        togglePin()
                    }, label: {
                        Image(systemName: postIsPinned() ? "pin.fill" : "pin")
                            .foregroundColor(.ffTertiary)
                            .padding(5)
                    })
                }
            }
            
            
        }.onAppear() {
            DispatchQueue.main.async {
                vm.get_post_from_day(day: getDayformatted(date: date)) { postID in
                    if postID.count > 0 {
                        self.post_id = postID
                        print(getDayformatted(date: date))
                        vm.firebase_get_post(postID: postID) { post in
                            self.url = post.images[0][0]
                        }
                    }
                }
            }
        }
    }
    func postIsPinned() -> Bool {
        if let id = post_id {
            return vm.current_user?.pins.contains(id) ?? false
        } else {
            return false
        }
    }
    
    func togglePin() {
        if let id = post_id {
            DispatchQueue.main.async {
                if postIsPinned() {
                    vm.firebase_remove_pin(postID: id) { removed in
                        // nothing for now
                        if removed {
                            print("removing")
                            vm.current_user?.pins.removeAll(where: { pinID in
                                pinID == id
                            })
                        }
                    }
                } else {
                    vm.firebase_add_pin(postID: id) { added in
                        // nothing for now
                        if added {
                            if !vm.current_user!.pins.contains(id) {
                                print("adding")
                                vm.current_user!.pins.append(id)
                            }
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
    CalendarItemView(date: Date(), vm: ViewModel(), frame: UIScreen.main.bounds.size.width / 3)
}
