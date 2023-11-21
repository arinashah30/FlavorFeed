//
//  MapView.swift
//  FlavorFeed
//
//  Created by Austin Huguenard on 10/3/23.
//
import SwiftUI
import MapKit

struct MyView: View {
    
    @StateObject var locationManager = LocationManager()
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    var body: some View {
        VStack {
            Text("location status: \(locationManager.statusString)")
            HStack {
                Text("latitude: \(userLatitude)")
                Text("longitude: \(userLongitude)")
            }
        }
    }
}

//struct MyView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyView()
//    }
//}

//Annotations
extension CLLocationCoordinate2D: Equatable, Hashable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
    

}

struct mapAnnotationView: View {
    var imageName: String
    var body: some View {
            Image(imageName)
                .resizable()
                .scaledToFit()
                //.border(Color.white, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .frame(maxWidth: 70)
                .overlay(
                            RoundedRectangle(cornerRadius: 9)
                                .stroke(Color.white, lineWidth: 3)
                        )
                .cornerRadius(9)
    }
}

struct MapView: View {
    //    @State var region: MKCoordinateRegion
    var user: User
    @State var restaurants: [CLLocationCoordinate2D]
    var body: some View{
        VStack{
            HStack {
                Text("Your Restaurants")
                    .font(.title2)
                    .padding()
                Spacer()
                Image(systemName: "person.2.fill")
                    .padding()
            }
            Map() {
                ForEach(restaurants, id: \.self) { restaurant in
                    Annotation("", coordinate: restaurant) {
                        mapAnnotationView(imageName: "waffles")
                    }
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MyView()
            MapView(user: User(id: "AustinUserName", name: "Austin", profilePicture: "drake_pfp", email: "austin@gmail.com", bio: "", phoneNumber: "123456789", friends: [], pins: [], myPosts: []), restaurants: [CLLocationCoordinate2D(latitude: 43, longitude: 100), CLLocationCoordinate2D(latitude: -10, longitude: 30), CLLocationCoordinate2D(latitude: 20, longitude: -50), CLLocationCoordinate2D(latitude: 17, longitude: -40)])
            
        }
    }
}
