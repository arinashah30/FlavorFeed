//
//  PostView.swift
//  FlavorFeed
//
//  Created by Rik Roy on 9/28/23.
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
                    Image("samplePFP")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70)
                        .clipShape(.circle)
                    
                    VStack (alignment: .leading) {
                        Text("Aubrey Drake Graham")
                            .font(.system(size: 20))
                            .foregroundColor(.ffSecondary)
                            .fontWeight(.semibold)
                        Text("Toronto • 7:00:02 AM")
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
                            }.padding(20).offset(x: 165, y: -220)

                            VStack {
                                
                                HStack {
                                    Button {
                                        self.showSelfieFirst.toggle()
                                    } label: {
                                        Image((showSelfieFirst) ? post.images[index][0] : post.images[index][1])
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 120, height: 180)
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
                                if post.caption[index] != "" {
                                    Text(post.caption[index])
                                        .background(RoundedRectangle(cornerRadius: 10.0)
                                            .frame(width: 300, height: 40)
                                            .foregroundColor(.ffTertiary))
                                        .padding(20)
                                }
                            }
                            
                        }.cornerRadius(20)
                            .padding(.bottom, 55)
                            .padding([.leading, .trailing] , 20)
                    }.frame(height:600)
                    
                }.tabViewStyle(.page).indexViewStyle(.page(backgroundDisplayMode: .always))
                    .frame(height: 610)
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
                                ForEach(post.comments!, id: \.self) { comment in
                                    HStack{
                                        Image(comment.profilePicture)
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .clipShape(.circle)
                                        Spacer()
                                        
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(gold)
                                            Text("**\(comment.username)**: \(comment.caption)")
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                                .padding(.horizontal, 10)
                                        }
                                        //                                    .frame(alignment: .leading)
                                        //                                    Text("**\(comment.username)**: \(comment.caption)")
                                        //                                        .padding(.horizontal, 7)
                                        //                                        .frame(width: .infinity, height: .infinity)
                                        //                                        .background(gold)
                                        //                                        .cornerRadius(10)
                                        //                                        .multilineTextAlignment(.leading)
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
            }
        }
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        
      }
}

#Preview {
    PostView(post: Post(id: UUID(), userID: UUID(), images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], caption: ["Let's dig in!", "", "That was yummy in my tummy"], date: "October 24, 2022", comments: [Comment(id: UUID(), username: "Adonis", profilePicture: "adonis_pfp", caption: "Looking fresh Drake!"), Comment(id: UUID(), username: "Travis Scott", profilePicture: "travis_scott_pfp", caption: "She said do you love me I told her only partly.")]))
//    PostView(selfiePic: "selfie", foodPic: "samplePic2", caption: "This is a sample caption")
}

