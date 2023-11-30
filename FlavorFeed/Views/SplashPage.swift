//
//  SplashPage.swift
//  FlavorFeed
//
//  Created by Arina Shah on 11/30/23.
//

import SwiftUI

struct SplashPage: View {
    //@State private var bounce = false
    
    var body: some View {
        ZStack {
            Color.ffTertiary.ignoresSafeArea(.all).background(Color.ffTertiary)
            VStack {
                Spacer()
                Image("flavorfeed_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .padding()
                    .padding(.top, 50)
                    //.offset(y: bounce ? -25 : 25)
//                    .animation(
//                        Animation.easeInOut(duration: 3)
//                                            .repeatForever(autoreverses: true)
//                    )

                
                Text("Welcome!").foregroundColor(Color.ffPrimary)
                    .font(.title)
                    .padding()
                    .padding(.top, 50)
                    .bold()
                
                
                Text("Just a minute while we set things up")
                    .foregroundColor(Color.ffSecondary)
                    //.padding(.top, 50)
                ProgressView()
                    .foregroundColor(Color.ffSecondary)
                    .tint(Color.ffSecondary)
                    .padding()
                Spacer()
            }
            
        }
//        .onAppear {
//            withAnimation {
//                self.bounce.toggle()
//            }
//        }
    }
}

#Preview {
    SplashPage()
}
