//
//  RecipeView.swift
//  FlavorFeed
//
//  Created by subha udhyakumar on 11/2/23.
//

import SwiftUI



struct RecipeView: View {
    let recipe: Recipe
    @State private var isSaveButtonTapped = false
    @State private var isShowingSheet = false
    var body: some View {
        Button(action: { isShowingSheet.toggle()})
        {
            Image("fork_and_knife")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35)
                .foregroundColor(.ffSecondary)
        }
        .sheet(isPresented: $isShowingSheet, onDismiss: didCancel) {
            ScrollView {
                VStack {
                    HStack {
                        
                        Button(action: {
                            // Handle save button action
                            isSaveButtonTapped = true
                        }) {
                            Image(systemName: "bookmark")
                                .foregroundColor(Color.ffSecondary)
                                .padding()
                                .font(.system(size: 30)).padding(5)
                        }
                        Spacer()
                        Text(recipe.title)
                            .font(.title)
                            .bold()
                            .foregroundColor(Color.ffSecondary)
                        Spacer()
                        Button(action: {
                            // Handle save button action
                            isSaveButtonTapped = true
                            isShowingSheet.toggle()
                        }) {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(Color.ffSecondary)
                                .padding()
                                .font(.system(size: 30)).padding(5)
                        }
                        
                    }
                    VStack{
                        if(recipe.link != nil) {
                            Text("Link to Recipe: ")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 30)
                                .foregroundColor(Color.ffSecondary)
                                .font(.system(size: 25))
                            Text(recipe.link!)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 30)
                        } else {
                            let formattedIngredients = recipe.ingredients.map { "• \($0)" }
                            let ingredientsText = formattedIngredients.joined(separator: "\n")
                            Text("Ingredients: ")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 30)
                                .foregroundColor(Color.ffSecondary)
                                .font(.system(size: 25))
                            Text(ingredientsText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 30)
                            Text("")
                            Text("Directions: ")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 30)
                                .foregroundColor(Color.ffSecondary)
                                .font(.system(size: 25))
                            Text(recipe.directions)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 30)
                                .padding(.trailing, 30)
                        }
                    }
                }
            }
        }
    }
    func didCancel() {
        }
    }
    


struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRecipe = Recipe(id: "id", title: "Fruit Salad", link: nil, ingredients: ["apple", "banana", "orange", "strawberry"], directions: "Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.")
        RecipeView(recipe: sampleRecipe)
    }
}
