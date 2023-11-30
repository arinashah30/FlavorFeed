//
//  ContentView.swift
//  flavorfeed_map
//
//  Created by Alena Tochilkina on 17.11.2023.
//

import SwiftUI
import MapKit

struct PickRestaurantView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var vm: ViewModel
    @ObservedObject var locationManager = LocationManager()
    @State private var searchText = ""
    @Binding var restaurant: Place?
    @State var places = [Place]()
    var body: some View {
        ZStack {
            VStack {
                Text("Nearby Restaurants")
                    .font(.title)
                    .underline()
                    .foregroundStyle(Color.ffPrimary)
                    .padding()
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search for restaurants",text: $searchText)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.systemGray5)))
                .frame(maxWidth: UIScreen.main.bounds.size.width * 0.9)
                .padding(.bottom, 10)
                
                List {
                    ForEach(places, id: \.self){ place in
                        Button(action: {
                            self.restaurant = place
                        }, label: {
                            VStack(alignment: .leading) {
                                Text(place.name)
                                    .foregroundStyle(Color.ffSecondary)
                            }
                            .frame(width: 320, alignment: .leading)
                            .padding()
                            .background(place == restaurant ? Color.ffPrimary : .white)
                            .cornerRadius(10)
                            
                        })
                    }
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                            .padding(30)
                            .background(Color.ffSecondary)
                            .clipShape(.circle)
                            .padding(15)
                    })
                    
                }
            }
        }.onChange(of: searchText, initial: true) { oldValue, newValue in
            Task {
                if let my_location = locationManager.get_my_location() {
                    print("getting locations")
                    await getPlacesNearby(for: Location(coordinate: my_location))
                }
            }
        }
    }
    
    func getPlacesNearby(for location: Location) async  {
        let urlString = "https://api.foursquare.com/v3/places/search"
        
        guard var urlComponents = URLComponents(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var params = [
            "ll": location.ll,
            "categories" : "13000", // only food places
            "sort": "DISTANCE",
            "limit" : "20"
        ]
        
        if self.searchText.count != 0 {
            params.updateValue(searchText, forKey: "query")
        }
        
        urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        
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
            
            let decodedResponse = try decoder.decode(Results.self, from: data)
            
            print("Places found: \(decodedResponse.results.count)")
            
            self.places = decodedResponse.results
            
        } catch {
            print("Error: \(error)")
        }
        
    }
}

struct Location {
    var ll: String
    
    init(coordinate: CLLocationCoordinate2D) {
        self.ll = "\(coordinate.latitude.description),\(coordinate.longitude.description)"
        print(ll)
    }
    
    init(latitude: Double, longitude: Double) {
        self.ll = "\(latitude),\(longitude)"
    }
}
struct Results: Decodable, Hashable {
    let results: [Place]
}

struct Place: Decodable, Hashable {
    let link: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case link
        case name
        
    }

}
