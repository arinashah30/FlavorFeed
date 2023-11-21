//
//  RecipeSheetView.swift
//  FlavorFeed
//
//  Created by subha udhyakumar on 11/16/23.
//

import SwiftUI

struct RecipeSheetView: View {
    let recipe: Recipe
    @State private var isSaveButtonTapped = false
    @Binding var isShowingSheet: Bool
    var body: some View {
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
                        //isSaveButtonTapped = true
                        isShowingSheet = false
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
                            .bold()
                        GeometryReader { geometry in
                                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                .frame(height: getHeight(for: recipe.link!, in: geometry.size.width))
                                            .foregroundColor(Color.ffTertiary)
                                            .padding(.leading, 25)
                                            .padding(.trailing, 25)
                                    }
                        Text(recipe.link!)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 35)
                            .background(Color.ffTertiary)
                    } else {
                        let formattedIngredients = recipe.ingredients!.map { "• \($0)" }
                        let ingredientsText = formattedIngredients.joined(separator: "\n")
                        Text("Ingredients: ")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 30)
                            .foregroundColor(Color.ffSecondary)
                            .font(.system(size: 25))
                            .bold()
                        GeometryReader { geometry in
                                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                            .frame(height: getHeight(for: ingredientsText, in: geometry.size.width))
                                            .foregroundColor(Color.ffTertiary)
                                            .padding(.leading, 25)
                                            .padding(.trailing, 25)
                                    }
                        Text(ingredientsText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 35)
                            //.background(Color.ffTertiary)
                        Spacer(minLength: 25)
                        Text("Directions: ")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 30)
                            .foregroundColor(Color.ffSecondary)
                            .font(.system(size: 25))
                            .bold()
                        GeometryReader { geometry in
                                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                .frame(height: getHeight(for: recipe.directions!, in: geometry.size.width))
                                            .foregroundColor(Color.ffTertiary)
                                            .padding(.leading, 25)
                                            .padding(.trailing, 25)
                                    }
                        Text(recipe.directions!)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 35)
                            .padding(.trailing, 30)
                            //.background(Color.ffTertiary)
                    }
                }
            }
        }
    }
}
func didCancel() {
}

func getHeight(for text: String, in width: CGFloat) -> CGFloat {
    let font = UIFont.systemFont(ofSize: 25)
    let boundingRect = NSString(string: text).boundingRect(
        with: CGSize(width: width - 60, height: .greatestFiniteMagnitude),
        options: .usesLineFragmentOrigin,
        attributes: [NSAttributedString.Key.font: font],
        context: nil
    )
    return boundingRect.height
}

struct RecipeSheetView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRecipe = Recipe(id: "id", title: "Fruit Salad", link: nil, ingredients: ["apple", "banana", "orange", "strawberry"], directions: "Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.")
        RecipeSheetView(recipe: sampleRecipe, isShowingSheet: .constant(true))
    }
}
//#Preview {
    //RecipeSheetView()
//}
