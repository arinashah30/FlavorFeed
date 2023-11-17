//
//  PublishPostView.swift
//  FlavorFeed
//
//  Created by Nicholas Candello on 11/16/23.
//

import SwiftUI

struct PublishPostView: View {
    @ObservedObject var vm: ViewModel
    
    @Binding var showCameraViewSheet: Bool
    @State private var showSelfieFirst = false
    
    @State private var caption: String = ""
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .center) {
                    HStack {
                        Button(action: {
                            self.showCameraViewSheet = false
                        }, label: {
                            Image(systemName: "chevron.left")
                                .frame(width: 15.07, height: 8.64)
                                .foregroundColor(.ffPrimary)
                        })
                        Spacer()
                    }
                    Image("flavorfeed_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 18.32)
                }.padding()
                    .frame(width: geo.size.width, height: geo.size.height * 0.05)
                    .background(.white)
                
                ZStack {
                    //
                    VStack {
                        Image(uiImage: getBigImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(25)
                    }
                    
                    VStack {
                        
                        HStack {
                            VStack {
                                Button {
                                    self.showSelfieFirst.toggle()
                                } label: {
                                    Image(uiImage: getSmallImage())
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
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            TextField("ADD CAPTION HERE", text: $caption)
                                .font(.system(size: 15))
                                .foregroundStyle(Color.ffSecondary)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color.ffTertiary)
                                .cornerRadius(15)
                                .padding()
                            
                            
                        }
                        
                    }
                    
                }.frame(width: geo.size.width, height: geo.size.height*0.66)
                    .padding(.top, 15)
                
                VStack(spacing: -15) {
                    HStack {
                        Button {
                            //
                        } label: {
                            HStack {
                                Image(systemName: "pin.fill")
                                    .font(.system(size: 15))
                                Text("Pin Post")
                            }.foregroundStyle(Color.ffSecondary)
                                .font(.system(size: 14))
                            
                                .padding(10)
                                .padding(.horizontal, 10)
                                .background(Color.ffTertiary)
                                .clipShape(Capsule())
                                .padding()
                        }
                        
                        Button {
                            //
                        } label: {
                            HStack {
                                Image("airplane")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 15, height: 15)
                                
                                Text("Moraine Lake, Alberta")
                                    .foregroundStyle(Color.ffSecondary)
                                    .font(.system(size: 14))
                            }
                            .padding(10)
                            .padding(.horizontal, 10)
                            .background(Color.ffTertiary)
                            .clipShape(Capsule())
                            .padding()
                            
                            
                        }
                        
                        
                    }
                    
                    HStack {
                        Button {
                            //
                        } label: {
                            HStack {
                                Image("spoon_and_knife")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 20, height: 20)
                                
                                Text("Add Recipe")
                                    .foregroundStyle(Color.ffSecondary)
                                    .font(.system(size: 14))
                            }
                            .padding(10)
                            .padding(.horizontal, 10)
                            .background(Color.ffTertiary)
                            .clipShape(Capsule())
                            .padding()
                        }
                        
                        Button {
                            //
                        } label: {
                            HStack {
                                Image("storefront")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 20, height: 20)
                                
                                Text("Add Restaurant")
                                    .foregroundStyle(Color.ffSecondary)
                                    .font(.system(size: 14))
                            }
                            .padding(10)
                            .padding(.horizontal, 10)
                            .background(Color.ffTertiary)
                            .clipShape(Capsule())
                            .padding()
                        }
                    }
                    
                    Button(action: {
                        // PUBLISH POST
                        vm.publish_post(caption: caption, location: "Atlanta, GA", recipe: Recipe(id: "1")) { close in
                            self.showCameraViewSheet = close
                        }
                    }, label: {
                        HStack {
                            Text("ADD")
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundStyle(.white)
                            Image("arrow_right")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 19.75, height: 17.38)
                            
                            
                        }
                        .padding(10)
                        .padding(.horizontal, 10)
                        .background(Color.ffPrimary)
                        .clipShape(Capsule())
                        .padding()
                        .padding(.top, 15)
                    })
                }
                Spacer()
            }.ignoresSafeArea(.keyboard)
        }.padding()
        .keyboardAdaptive()
    }
    
    func getBigImage() -> UIImage {
        return showSelfieFirst ? vm.photo_2! : vm.photo_1!
    }
    
    func getSmallImage() -> UIImage {
        return showSelfieFirst ? vm.photo_1! : vm.photo_2!
    }
}

struct PublishPostView_Previews: PreviewProvider {
    @ObservedObject static var vm =  ViewModel(photo1: UIImage(named: "food_pic_1"), photo2: UIImage(named: "drake_selfie"))
    
    static var previews: some View {
        PublishPostView(vm: vm, showCameraViewSheet: Binding.constant(true))
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
}

struct KeyboardAdaptive: ViewModifier {
    @State private var currentHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, currentHeight)
            .onAppear(perform: subscribeToKeyboardEvents)
    }

    private func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification,
            object: nil,
            queue: .main
        ) { notification in
            guard let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
            }

            self.currentHeight = UIScreen.main.bounds.height - keyboardRect.origin.y
        }
    }
}
