//
//  FriendProfileView.swift
//  FlavorFeed
//
//  Created by Julia Kim on 10/3/23.
//

import SwiftUI
import MapKit

struct FriendProfileView: View {
    @Binding var tabSelection: Tabs
    var body: some View {
        let friendData = User(id: "ID(", name: "Julia Kim", username: "juliakim361", profilePicture: "image.png", email: "jk@gmail.com", favorites:
                                [Post(id: UUID(), images: ["waffles", "random"], caption: "nothing", date: "nothing", likes: [], comments: [], location: "none"),
                                 Post(id: UUID(), images: ["waffles", "random"], caption: "nothing", date: "nothing", likes: [], comments: [], location: "none"),
                                 Post(id: UUID(), images: ["waffles", "random"], caption: "nothing", date: "nothing", likes: [], comments: [], location: "none")]
                              , friends: [], savedPosts: [], bio: "hello", myPosts: [Post(id: UUID(), images: ["dummy.jpeg", "caption"], caption: "hello", recipe: "recipe", date: "9/1/23", likes: [], comments: [], location: "atlanta")], phoneNumber: 1234567890, location: "atlanta", myRecipes: ["chicken", "pasta"])
        
        VStack {
            HStack(){
                Button{
                    self.tabSelection = .mainScrollView
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.red)
                        .font(.system(size: 40))
                }
                Spacer()
                
                Text(friendData.name)
                    .font(.system(size: 40))
                    .frame(alignment: .center)
                
                Spacer()
                
                Button{
                    self.tabSelection = .selfProfileView // need to change this
                } label: {
                    Image(systemName: "person.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 40))
                }
                .frame(alignment: .trailing)
            }
            
            BioView(user: friendData)
            ContentView()
        }
        .padding(.top, 50)
    
        Spacer()
        
        VStack {
            ZStack{
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .fill(Color(.systemGray6))
            HStack {
                ZStack{
                    Image("food_example")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                        .border(Color.yellow)
                        .cornerRadius(20)
                    Image("person_example")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, alignment: .leading)
                        .border(Color.red)
                        .cornerRadius(10)
                        .offset(x:-30,y:-50)
                }
                    VStack {
                        Text("Today's Flavor Feed")
                            .font(.system(size:20)).bold()
                        Text("Washington, Georgetown - 5 hrs late").lineLimit(1)
                        Spacer()
                        Button(action: {
                        }) {
                            Text("Add a comment...")
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .font(.system(size:15))
                                .cornerRadius(20)
                        }
                    }
                }
            }
            Text("Map View")
                .font(.title3).bold()
                .frame(maxWidth: 370, maxHeight: 30, alignment: .leading)
            @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 33.7488, longitude: -84.3877), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            Map(coordinateRegion: $region)
                        .frame(width: 400, height: 300)
            }
        
            //let overlay = ImageOverlay(image: myImage, rect: desiredLocationAsMapRect)
            //mapView.add(overlay)
            //.border(.white)
        }
    
    struct BioView: View {
        var user: User
        var body: some View {
            VStack {
                Image("profile Pic 2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 100, maxHeight: 200)
                    .clipShape(.ellipse)
                
                
                Text(user.username)
                    .font(.title)
                
                Text("Friend for 2 years")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                
            }
        }
    }

    
    struct ContentView: View {
        var body: some View {
            
            HStack{
                ZStack {
                           Circle()
                               .fill(Color.blue)
                               .frame(width: 100, height: 50) // Adjust width and height as needed
                               .offset(x: -150, y: 0) // Offset the first ellipse up by half its height
                           
                           Circle()
                               .fill(Color.green)
                               .frame(width: 100, height: 50)
                               .offset(x: -120, y: 0)
                           
                            Circle()
                                .fill(Color.red)
                                .frame(width: 100, height: 50)
                                .offset(x: -90, y: 0)
                    
                    Text("Friend with Yul, Shan and 31 more")
                        .offset(x: 40)
                        .frame(maxWidth: 200)
                        .background(Color.clear)
                        .foregroundColor(.gray)
                }.offset(x:0)
                
            }
            .padding()
        }
    }
    
    
    }


#Preview {
    FriendProfileView(tabSelection: Binding.constant(Tabs.mainScrollView))
}
