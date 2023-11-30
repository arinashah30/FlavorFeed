//
//  PublishPostView.swift
//  FlavorFeed
//
//  Created by Nicholas Candello on 11/16/23.
//

import SwiftUI
import CoreLocation


struct PublishPostView: View {
    @ObservedObject var vm: ViewModel
    @ObservedObject var locationManager = LocationManager()
    
    @Binding var showCameraViewSheet: Bool
    @State private var showPickRestaurantSheet = false
    @State private var showSelfieFirst = false
    @State private var locationText = "Atlanta, GA"
    @State private var caption: String = ""
    @State private var isShowingRecipeForm: Bool = false
    @State private var recipe: Recipe?
    @State private var restaurant: Place?
    @State private var pinned: Bool = false
    
    var body: some View {
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
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.05)
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
                                    .frame(width: UIScreen.main.bounds.size.width * 0.30, height: UIScreen.main.bounds.size.height * 0.2)
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
                            .padding(.leading, 8)
                            .padding(.vertical, 8)
                            .background(Color.ffTertiary)
                            .cornerRadius(15)
                            .padding()
                        
                        
                    }
                    
                }
                
            }.frame(width: UIScreen.main.bounds.size.width * 0.95, height: UIScreen.main.bounds.size.height * 0.66)
                .padding(.top, 15)
            
            VStack(spacing: -15) {
                HStack {
                    Button {
                        pinned.toggle()
                    } label: {
                        HStack {
                            Image(systemName: pinned ? "pin.fill" : "pin")
                                .font(.system(size: 15))
                            Text(pinned ? "Pinned" : "Pin Post")
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
                            
                            Text(self.locationText)
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
                        isShowingRecipeForm = true
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
                        self.showPickRestaurantSheet.toggle()
                    } label: {
                        HStack {
                            Image("storefront")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                            
                            Text(restaurant == nil ? "Add Restaurant" : restaurant!.name)
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
                    var locationString = ""
                    if let restaurant = restaurant {
                        locationString = "\(restaurant.name)|||||\(restaurant.link)"
                    } else {
                        locationString = locationText
                    }
                    vm.publish_post(caption: caption, location: locationString, recipe: recipe, pinned: pinned) { close in
                        print("Recipe uploaded: \((!close).description)")
                        if !close {
                            vm.refreshFeed() {
                                print("refresh feed done")
                                self.showCameraViewSheet = false
                            }
                            
                        }
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
        }.onAppear {
            self.pinned = vm.current_user?.pins.contains(vm.my_post_today?.id ?? "") ?? false
        }
        .task {
            await get_my_location_description()
        }
        .onDisappear() {
            vm.photo_1 = nil
            vm.photo_2 = nil
            vm.bothImagesCaptured = false
        }.sheet(isPresented: $showPickRestaurantSheet, content: {
            PickRestaurantView(vm: vm, restaurant: $restaurant)
                
        })
        .sheet(isPresented: $isShowingRecipeForm) {
            RecipeFormView(recipe: $recipe, isPresentingRecipeForm: $isShowingRecipeForm)
        }
        
    }
    
    func getBigImage() -> UIImage {
        return showSelfieFirst ? vm.photo_2! : vm.photo_1!
    }
    
    func getSmallImage() -> UIImage {
        return showSelfieFirst ? vm.photo_1! : vm.photo_2!
    }
    
    func get_my_location_description() async {
        let geocoder = locationManager.geocoder
        if let location = locationManager.lastLocation {
            do {
                let place = try await geocoder.reverseGeocodeLocation(location)
                
                if let city = place[0].locality, let state = place[0].administrativeArea {
                    self.locationText = "\(city), \(state)"
                    print("\(city), \(state)")
                }
            } catch {
                print(error)
            }
        }
    }
}

struct PublishPostView_Previews: PreviewProvider {
    @ObservedObject static var vm =  ViewModel(photo1: UIImage(named: "food_pic_1"), photo2: UIImage(named: "drake_selfie"))
    
    static var previews: some View {
        PublishPostView(vm: vm, showCameraViewSheet: Binding.constant(true))
    }
}
