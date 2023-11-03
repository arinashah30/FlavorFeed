//
//  MapView.swift
//  FlavorFeed
//
//  Created by Austin Huguenard on 10/3/23.
//

import SwiftUI
import MapKit

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
                .frame(maxWidth: 45)
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
        Map() {
            ForEach(restaurants, id: \.self) { restaurant in
                Annotation("", coordinate: restaurant) {
                    mapAnnotationView(imageName: "waffles")
                }
            }
        }
    }
}
