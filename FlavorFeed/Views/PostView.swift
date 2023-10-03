//
//  PostView.swift
//  FlavorFeed
//
//  Created by Rik Roy on 9/28/23.
//

import SwiftUI

struct PostView: View {
    //var user: User
    var body: some View {
        VStack {
            HStack {
                Image("profilePic")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80)
                
                VStack (alignment: .leading) {
                    Text("Name");
                    Text("Location Time")
                    
                }
                
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "line.3.horizontal.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25)
                }
            }.padding([.leading, .trailing] , 20)
            
            TabView {
                ForEach(1...3, id: \.self) { pic in
                    ZStack (){
                        Image("samplePic")
                            .resizable()
                            .frame(width: 350)

                        VStack {
                            
                            Button {
                                
                            } label: {
                                Circle()
                                    .foregroundColor(.red)
                                    .frame(width: 50)
                            }
                            
                            Button {
                                
                            } label: {
                                Circle()
                                    .foregroundColor(.red)
                                    .frame(width: 50)
                            }
            
                        }.padding(.leading, 250)
                            .padding(.bottom, 400)
                        
                        
                        
                        //RoundedRectangle(cornerRadius: 20.0)
                            //.frame(width: 100, height: 20)
                        
                        
                        
                        
                    }.cornerRadius(30)
                    .padding(.bottom, 55)
                        .padding([.leading, .trailing] , 20)
                        
                }
                
            }.tabViewStyle(.page).indexViewStyle(.page(backgroundDisplayMode: .never)).padding(.bottom, 50)
                .onAppear {
                    setupAppearance()
                }
                
            
        }
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
      }
}

#Preview {
    PostView()
}
