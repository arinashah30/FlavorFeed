//
//  MapView.swift
//  FlavorFeed
//
//  Created by Austin Huguenard on 10/3/23.
//
import SwiftUI
import MapKit

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
    @StateObject var locationManager = LocationManager()
    
    @ObservedObject var vm: ViewModel
    @State private var posts: [Post]
    @State private var myPins = [Pin]()
    @Binding var showFullMap: Bool
    
    @State private var showPostSheet = false
    @State private var selectedPost: Post? = nil
    
    init(vm: ViewModel, showFullMap: Binding<Bool>, posts: [Post] = [], friendPosts: Binding<[Post]?> = Binding.constant(nil)) {
        self.vm = vm
        self._showFullMap = showFullMap
        self.posts = friendPosts.wrappedValue != nil ? friendPosts.wrappedValue! : posts
    }
    
    var body: some View{
        VStack{
            HStack {
                Button(action: {
                    self.showFullMap.toggle()
                }, label: {
                    Image(systemName: "chevron.left")
                        .padding()
                })
                Text("Your Restaurants")
                    .font(.title2)
                    .padding()
                Spacer()
            }.foregroundColor(.black)
            
            Map() {
                UserAnnotation()
                ForEach(self.myPins, id: \.self) { pin in
                    Annotation(pin.place.name, coordinate: CLLocationCoordinate2D(latitude: pin.place.geocodes.main.latitude, longitude: pin.place.geocodes.main.longitude)) {
                        Button(action: {
                            // nothing for now
                            self.selectedPost = pin.post
                            self.showPostSheet.toggle()
                        }, label: {
                            vm.imageLoader.img(url: URL(string: pin.post.images[pin.postIndex][0])) { image in
                                image.resizable()
                            }.aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                                .cornerRadius(10)
                        })
                        
                    }
                }
            }
                     }.onAppear() {
                         Task {
                             await self.populateAllPlaces(posts: posts)
                         }
                     }.sheet(item: $selectedPost, content: { post in
                         MyPostView(vm: vm, showMyPostView: $showPostSheet, post: post)
                     })
    }
    func populateAllPlaces(posts: [Post]) async {
        for post in posts {
            if let link = post.locationLink {
                for i in 0..<link.count {
                    await getPlaceFromLink(post: post, index: i)
                }
            }
        }
    }
    func getPlaceFromLink(post: Post, index: Int) async {
        let urlString = "https://api.foursquare.com\(post.locationLink![index])"
        
        guard var urlComponents = URLComponents(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        print(urlComponents.url?.absoluteString)
        var request = URLRequest(url: urlComponents.url!)
        
        // setting headers
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("fsq3WNw5aEH2EMpBBI2iRc4FU2sJHHQr/xJUhdvCYp/dHgI=", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        request.timeoutInterval = 5
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            print("Data received (Size: \(data.count))")
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            print("DATA: \(String(data: data, encoding: .utf8) ?? "Invalid JSON data")")
            
            let decodedResponse = try decoder.decode(Place.self, from: data)
            
            print("Places found: \(decodedResponse)")
           
            
            self.myPins.append(Pin(place: decodedResponse, post: post, postIndex: index))
            
        } catch {
            print("Error: \(error)")
        }
    }

}

struct Pin: Hashable {
    let place: Place
    let post: Post
    let postIndex: Int
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MapView(vm: ViewModel(), showFullMap: Binding.constant(true), posts: [])
        }
    }
}
