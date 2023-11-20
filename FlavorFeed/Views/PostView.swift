//
//  PostView.swift
//  FlavorFeed
//
//  Created by Datta Kansal and Shaunak Karnik on 9/28/23.
//

import SwiftUI


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

    var post_images = [[Image]]()
    
    var profilePicture: Image
    
    init(vm: ViewModel, post: Post) {
        print(post)
        self.vm = vm
        
        self.post = post
        
        profilePicture = vm.load_image_from_url(url: post.friend?.profilePicture ?? "NIL") ?? Image(systemName: "person.circle")
        
        for entry in 0..<post.images.count {
            var postEntry: [Image] = [Image]()
            print("Size of post entry: \(post.images[entry].count)")
            for picSide in 0..<2 {
                postEntry.append(vm.load_image_from_url(url: post.images[entry][picSide]) ?? Image(systemName: "person.circle"))
            }
            post_images.append(postEntry)
            print("Size: \(post_images[0].count)")
        }
    }

    @State private var isShowingSheet = false

    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    profilePicture
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.height * 0.08)
                        .clipShape(.circle)
                    
                    VStack (alignment: .leading) {
                        Text(post.userID)
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
                    ForEach(0..<post_images.count) { index in
                        
                        ZStack (){
                            bigImage(index)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geo.size.width*0.98, height: geo.size.height*0.66)
                                .clipped()
                            

                            VStack {
                                
                                HStack {
                                    VStack {
                                        Button {
                                            self.showSelfieFirst.toggle()
                                        } label: {
                                            smallImage(index)
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
                        Text("Top Comments")
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
                    if showComments && post.comments != nil {
                        ScrollView {
                            VStack {
                                ForEach(post.comments, id: \.self) { comment in
                                    HStack{
//                                        Image(comment.profilePicture)
                                        Image("travis_scott_pfp")
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .clipShape(.circle)
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
                                
                            }
                            .padding(.vertical)
                            .background(lightGray)
                            .cornerRadius(20)
                            .padding(.bottom, 8)
                        }
                        .frame(width: geo.size.width * 0.97)
                    }
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
    
    func bigImage(_ i: Int) -> Image {
        return showSelfieFirst ? post_images[i][0] : post_images[i][1]
    }
    
    func smallImage(_ i: Int) -> Image {
        return showSelfieFirst ? post_images[i][1] : post_images[i][0]
    }
    
    mutating func populateFriend(friend: Friend) {
        
    }
}

#Preview {

    let sampleRecipe = Recipe(id: "id", title: "Fruit Salad", link: nil, ingredients: ["apple", "banana", "orange", "strawberry"], directions: "Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.")
    PostView(vm: ViewModel(), post: Post(id: UUID().uuidString, userID: "champagnepapi", images: ["drake_selfie food_pic_1", "drake_selfie2 food_pic_2", "drake_selfie3 food_pic_3"], date: ["October 24, 2022", "October 24, 2022", "October 24, 2022"], day: "October 23", comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "October 24, 2022", replies: []), Comment(id: UUID().uuidString, userID: "travisscott", text: "She said do you love me I told her only partly.", date: "October 24, 2022", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: [sampleRecipe, sampleRecipe, sampleRecipe], friend: nil))
    
    
}


