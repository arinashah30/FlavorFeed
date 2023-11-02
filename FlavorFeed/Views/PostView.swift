//
//  PostView.swift
//  FlavorFeed
//
//  Created by Datta Kansal and Shaunak Karnik on 9/28/23.
//

import SwiftUI

struct PostView: View {
    var post: Post
//    var userID: String
    var gold = Color(red:255/255, green:211/255, blue:122/255)
    var salmon = Color(red: 255/255, green: 112/255, blue: 112/255)
    var teal = Color(red: 0/255, green: 82/255, blue: 79/255)
    var lightGray = Color(red: 238/255, green: 238/255, blue: 239/255)
    
    @State private var showSelfieFirst = true
    @State private var showComments = true
//     let selfiePic: String
//     let foodPic: String
//     let caption: String
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    Image("drake_pfp")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.height * 0.08)
                        .clipShape(.circle)
                    
                    VStack (alignment: .leading) {
                        Text("Aubrey Drake Graham")
                            .font(.system(size: 18))
                            .foregroundColor(.ffSecondary)
                            .fontWeight(.semibold)
                        Text("Toronto, ON • 7:00 AM")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                    }
                    
                    Spacer()
                    Button {
                    } label: {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                            .foregroundColor(.black)
                    }
                }.padding([.leading, .trailing] , 20)
                
                TabView {
                    ForEach(0..<post.images.count) { index in
                        
                        //                ForEach(1...3, id: \.self) { pic in
                        ZStack (){
                            //
                            Image((showSelfieFirst) ? post.images[index][1] : post.images[index][0])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geo.size.width*0.98, height: geo.size.height*0.66)
                                .clipped()
                            

                            VStack {
                                
                                HStack {
                                    VStack {
                                        Button {
                                            self.showSelfieFirst.toggle()
                                        } label: {
                                            Image((showSelfieFirst) ? post.images[index][0] : post.images[index][1])
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: geo.size.width * 0.30, height: geo.size.height * 0.2)
                                                .clipped()
                                        }
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.ffPrimary, lineWidth: 2)
                                        )
                                    .padding()
                                        Spacer()
                                    }
                                    Spacer()
                                    VStack {
                                        Button {
                                            
                                        } label: {
                                            Image("fork_and_knife")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 35)
                                                .foregroundColor(.ffTertiary)
                                        }
                                        
                                        Button {
                                            
                                        } label: {
                                            Image("Restaurant_logo")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 35)
                                        }
                                        Spacer()
                                    }.padding()

                                }
                                Spacer()
                                if post.caption[index] != "" {
                                    Text(post.caption[index])
                                        .background(RoundedRectangle(cornerRadius: 10.0)
                                            .frame(width: geo.size.width * 0.7, height: geo.size.height * 0.05)
                                            .foregroundColor(.ffTertiary))
                                        .padding(20)
                                }
                            }
                            
                        }.cornerRadius(20)
                            .padding(.bottom, 55)
                            .padding([.leading, .trailing] , 20)
                    }.frame(height: geo.size.height * 0.69)
                    
                }.tabViewStyle(.page).indexViewStyle(.page(backgroundDisplayMode: .always))
                    .frame(height: geo.size.height * 0.735)
                    .onAppear {
                        setupAppearance()
                    }
                
                VStack{
                    HStack{
                        Text("Top Comments")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                        Spacer()
                        Button {
                            withAnimation (.smooth) {
                                self.showComments.toggle()
                            }
                        } label: {
                            Image(systemName: self.showComments ? "chevron.down" : "chevron.up")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
                    if showComments && post.comments != nil {
                        ScrollView {
                            VStack {
                                ForEach(post.comments, id: \.self) { comment in
                                    HStack{
//                                        Image(comment.profilePicture)
                                        Image("travis_scott_pfp")
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .clipShape(.circle)
                                        Spacer()
                                        
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(gold)
                                            Text("**\(comment.userID)**: \(comment.text)")
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                                .padding(.horizontal, 10)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 15)
                                }
                                
                            }
                            .padding(.vertical)
                            .background(lightGray)
                            .cornerRadius(20)
                            .padding(.bottom, 5)
                        }
                    }
                }
                Spacer()
            }.frame(maxHeight: .infinity)
        }
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        
      }
}

#Preview {
    PostView(post: Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["October 24, 2022", "October 24, 2022", "October 24, 2022"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "October 24, 2022", replies: []), Comment(id: UUID().uuidString, userID: "travisscott", text: "She said do you love me I told her only partly.", date: "October 24, 2022", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: [], day: "October 24, 2022"))
}
