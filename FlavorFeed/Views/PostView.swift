//
//  PostView.swift
//  FlavorFeed
//
//  Created by Rik Roy on 9/28/23.
//

import SwiftUI

struct PostView: View {
    //var user: User
    var gold = Color(red:255/255, green:211/255, blue:122/255)
    var salmon = Color(red: 255/255, green: 112/255, blue: 112/255)
    var teal = Color(red: 0/255, green: 82/255, blue: 79/255)
    
    
    var body: some View {
        VStack {
            HStack {
                Image("samplePFP")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80)
                
                VStack (alignment: .leading) {
                    Text("Name")
                        .font(.system(size: 20))
                        .foregroundColor(teal)
                        .fontWeight(.semibold)
                    Text("Location • Time")
                        .font(.system(size: 15))
                        .fontWeight(.light)
                }
                
                Spacer()
                Button {
                } label: {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25)
                        .foregroundColor(.black)
                }
            }.padding([.leading, .trailing] , 20)
            
            TabView {
                ForEach(1...3, id: \.self) { pic in
                    ZStack (){
                        Image("samplePic2")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                           .frame(width: 390, height: 550)
                            .clipped()

                        VStack {
                            Button {
                                
                            } label: {
                                Image("fork_and_knife")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 35)
                                    .foregroundColor(gold)
                            }
                            
                            Button {
                                
                            } label: {
                                Image("Restaurant_logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 35)
                            }
                        }.padding(20).offset(x: 165, y: -220)
                        
                        Text("This is a sample caption")
                            .offset(x: 0, y: 245)
                            .background(RoundedRectangle(cornerRadius: 10.0)
                                .frame(width: 300, height: 40)
                                .offset(x: 0, y: 245)
                                .foregroundColor(gold))
                        
                        Image("selfie")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 180)
                            .clipped()
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(salmon, lineWidth: 2))
                            .offset(x: -120, y: -170)
                    }.cornerRadius(20)
                    .padding(.bottom, 55)
                        .padding([.leading, .trailing] , 20)
                }
                
            }.tabViewStyle(.page).indexViewStyle(.page(backgroundDisplayMode: .always))
                .onAppear {
                    setupAppearance()
                }
            
//            Spacer().frame(height: 60)
                
            VStack{
                HStack{
                    Text("Top Comments")
                        .font(.system(size: 15))
                        .fontWeight(.light)
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "chevron.up")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15)
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 5)
                VStack {
                    ForEach(1...2, id: \.self) { comment in
                        HStack{
                            Image("samplePFP")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60)
                            Spacer()
                            HStack{
                                Text("Name:")
                                Text("This is a sample comment that would be below a post")
                            }
                            .frame(width: 300, height: 60)
                            .background(gold)
                            .cornerRadius(10)
                            Spacer()
                        }
                        .padding(.horizontal, 15)
                    }
//                    .background(Color.gray)
                }
                .padding(.bottom, 5)
 //               Spacer().frame(height: 50)
            }
        }
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        
      }
}

#Preview {
    PostView()
}
