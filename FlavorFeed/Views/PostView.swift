//
//  PostView.swift
//  FlavorFeed
//
//  Created by Datta Kansal and Shaunak Karnik on 9/28/23.
//

import SwiftUI
import Combine


struct PostView: View {
    @ObservedObject var vm: ViewModel
    @State private var tabSelection = 0
    var post: Post
    
    var gold = Color(red:255/255, green:211/255, blue:122/255)
    var salmon = Color(red: 255/255, green: 112/255, blue: 112/255)
    var teal = Color(red: 0/255, green: 82/255, blue: 79/255)
    var lightGray = Color(red: 238/255, green: 238/255, blue: 239/255)
    
    @State private var showSelfieFirst = true
    
    @State private var showComments = true
    @State private var myNewComment = ""
    @State private var isShowingSheet = false
    
    
    let person_circle_address = "https://www.iconbolt.com/preview/facebook/ionicons-outline/person-circle.svg"
    
    init(vm: ViewModel, post: Post) {
        self.vm = vm
        
        self.post = post
        print("CREATING POST")
        print(vm.todays_posts.count)
        
        self.post.comments = self.post.comments.sorted { this, next in
            this.date < next.date
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    AsyncImage(url: URL(string: post.friend!.profilePicture)) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: geo.size.height * 0.08, height: geo.size.height * 0.08)
                            .clipShape(.circle)
                    } placeholder: {
                        ProgressView()
                            .frame(width: geo.size.height * 0.08, height: geo.size.height * 0.08)
                            .clipShape(.circle)
                        
                    }.task {
                        do {
                            _ = try await URLSession.shared.data(from: URL(string: post.friend!.profilePicture)!)
                            // The image loaded successfully
                            print("Image loaded successfully")
                        } catch {
                            print("Error loading image: \(error.localizedDescription)")
                        }
                    }
                    
                    
                    VStack (alignment: .leading) {
                        Text(post.friend!.name)
                            .font(.system(size: 18))
                            .foregroundColor(.ffSecondary)
                            .fontWeight(.semibold)
                        Text("\(post.locations[tabSelection]) • \(formatPostTime(time: post.date[tabSelection]))")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                    }
                    
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                            .foregroundColor(.black)
                    }
                }
                .padding([.leading, .trailing] , 20)
                
                TabView(selection: $tabSelection) {
                    ForEach(0..<post.images.count) { index in
                        
                        ZStack (){
                            AsyncImage(url: URL(string: bigImage(index))) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geo.size.width*0.98, height: geo.size.height*0.66)
                                    .clipped()
                            } placeholder: {
                                ProgressView()
                                    .frame(width: geo.size.width*0.98, height: geo.size.height*0.66)
                                    .clipped()
                                
                                
                                
                            }
                            
                            
                            VStack {
                                HStack {
                                    VStack {
                                        Button {
                                            self.showSelfieFirst.toggle()
                                        } label: {
                                            AsyncImage(url: URL(string: smallImage(index))) { image in
                                                image.resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: geo.size.width * 0.30, height: geo.size.height * 0.2)
                                                    .clipped()
                                                    .cornerRadius(10)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(Color.ffPrimary, lineWidth: 2)
                                                    )
                                                    .padding()
                                            } placeholder: {
                                                ProgressView()
                                                    .frame(width: geo.size.width * 0.30, height: geo.size.height * 0.2)
                                                    .clipped()
                                                    .cornerRadius(10)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(Color.ffPrimary, lineWidth: 2)
                                                    )
                                                    .padding()
                                            }
                                            
                                        }
                                        Spacer()
                                    }
                                    Spacer()
                                    VStack {
                                        Button {
                                            isShowingSheet = true
                                        } label: {
                                            Image("fork_and_knife")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 35)
                                                .foregroundColor(.ffTertiary)
                                        }
                                        
                                        
                                        
                                        Button {
                                            
                                        } label: {
                                            Image("Restaurant_logo")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 35)
                                        }
                                        Spacer()
                                    }.padding()
                                    
                                }
                                Spacer()
                                if index < post.caption.count {
                                    Text(post.caption[index])
                                        .background(RoundedRectangle(cornerRadius: 10.0)
                                            .frame(width: geo.size.width * 0.7, height: geo.size.height * 0.05)
                                            .foregroundColor(.ffTertiary))
                                        .padding(20)
                                }
                            }
                            
                        }.cornerRadius(20)
                            .padding(.bottom, 55)
                            .padding([.leading, .trailing] , 20)
                            .tag(index)
                            .sheet(isPresented: $isShowingSheet) {
                                RecipeSheetView(recipe: post.recipes[index], isShowingSheet: $isShowingSheet)
                            }
                    }.frame(height: geo.size.height * 0.69)
                    
                }.tabViewStyle(.page).indexViewStyle(.page(backgroundDisplayMode: .always))
                    .frame(height: geo.size.height * 0.725)
                    .onAppear {
                        setupAppearance()
                    }
                
                
                VStack{
                    HStack{
                        Text("Top Comments (\(post.comments.count))")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding(.top, -2)
                        Spacer()
                        
                        Button {
                            withAnimation (.smooth) {
                                self.showComments.toggle()
                            }
                        } label: {
                            Image(systemName: self.showComments ? "chevron.down" : "chevron.up")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
                    if showComments && post.comments.count != 0 {
                        VStack {
                            ForEach(post.comments, id: \.self) { comment in
                                HStack{
                                    AsyncImage(url: URL(string: comment.profilePicture)) { image in
                                        image
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .clipShape(.circle)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 60, height: 60)
                                            .clipShape(.circle)
                                    }
                                    Spacer()
                                    
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(gold)
                                        Text("**\(comment.userID)**: \(comment.text)")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .multilineTextAlignment(.leading)
                                            .padding(.horizontal, 10)
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 15)
                                
                            }
                            .padding(.vertical)
                            .background(lightGray)
                            .cornerRadius(20)
                            .padding(.bottom, 8)
                        }
                        
                    }
                    HStack {
                        TextField("Add comment here", text: $myNewComment)
                        Button {
                            // add comment
                            vm.firebase_add_comment(postID: post.id, text: myNewComment, date: Date()) { uploaded in
                                if uploaded {
                                    myNewComment = ""
                                    vm.refreshFeed {
                                        // do nothing
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "paperplane.circle")
                                .foregroundColor(.ffSecondary)
                                .font(.system(size: 24))
                        }
                    }.frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .background(Color.ffPrimary)
                        .cornerRadius(10)
                        .padding()
                    
                }
                .padding(.top, -7)
                Spacer()
            }.frame(maxHeight: .infinity)
        }
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        
    }
    
    func formatPostTime(time: String) -> String {
        let dateFormatterIn = DateFormatter()
        dateFormatterIn.dateFormat = "MM-dd-yyyy HH:mm:ss"
        let date = dateFormatterIn.date(from: time)!
        
        let dateFormatterOut = DateFormatter()
        dateFormatterOut.dateFormat = "HH:mm a"
        return dateFormatterOut.string(from: date)
    }
    
    func bigImage(_ i: Int) -> String {
        print("BIG IMAGE: \(showSelfieFirst ? post.images[i][0] : post.images[i][1])")
        return showSelfieFirst ? post.images[i][0] : post.images[i][1]
    }
    
    func smallImage(_ i: Int) -> String {
        print("SMALL IMAGE: \(showSelfieFirst ? post.images[i][1] : post.images[i][0])")
        return showSelfieFirst ? post.images[i][1] : post.images[i][0]
    }
}

//#Preview {
//    let sampleRecipe = Recipe(id: "id", title: "Fruit Salad", link: nil, ingredients: ["apple", "banana", "orange", "strawberry"], directions: "Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.")
//    PostView(vm: ViewModel(), post: Post(id: UUID().uuidString, userID: "champagnepapi", images: ["https://pbs.twimg.com/media/F3xazUkawAEeDOc.jpg:large https://cdn.openart.ai/stable_diffusion/cc2c55c983affcc95f0bfd881d62eb446e2a4c69_2000x2000.webp"], date: ["October 24, 2022", "October 24, 2022", "October 24, 2022"], day: "11-09-2923", comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "October 24, 2022", replies: []), Comment(id: UUID().uuidString, userID: "travisscott", text: "She said do you love me I told her only partly.", date: "October 24, 2022", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: [sampleRecipe, sampleRecipe, sampleRecipe], friend: Friend(id: "arinashah", name: "Arina", profilePicture: "https://images-prod.dazeddigital.com/463/azure/dazed-prod/1300/0/1300889.jpeg", bio: "Nothing", mutualFriends: [], pins: [], todaysPosts: [])))
//}
