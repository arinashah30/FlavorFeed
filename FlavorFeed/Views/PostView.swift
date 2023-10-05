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
    
    
    var body: some View {
        VStack {
            HStack {
                Image("profilePic")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80)
                
                VStack (alignment: .leading) {
                    Text("Name");
                    Text("Location • Time")
                    
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
                                Circle()
                                    .foregroundColor(.red)
                                    .frame(width: 20)
                            }
                            
                            Button {
                                
                            } label: {
                                Circle()
                                    .foregroundColor(.red)
                                    .frame(width: 20)
                            }
                        }.padding(20).offset(x: 150, y: -225)
                        
                        Text("This is a sample caption")
                            .offset(x: 0, y: 250)
                            .background(RoundedRectangle(cornerRadius: 10.0)
                                .frame(width: 300, height: 40)
                                .offset(x: 0, y: 250)
                                .foregroundColor(gold))
                        
                        Image("selfie")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 180)
                            .clipped()
                            .cornerRadius(20)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(salmon, lineWidth: 4))
                            .offset(x: -120, y: -170)
                        
                        
                        
                        
                        
                    }.cornerRadius(20)
                    .padding(.bottom, 55)
                        .padding([.leading, .trailing] , 20)
                    
                        
                }
                
            }.tabViewStyle(.page).indexViewStyle(.page(backgroundDisplayMode: .always))
                .onAppear {
                    setupAppearance()
                }
            
            Spacer().frame(height: 60)
                
            
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
