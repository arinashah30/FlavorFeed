//
//  CreateRecipeView.swift
//  FlavorFeed
//
//  Created by Misry Dhanani on 11/2/23.
//

import SwiftUI

struct CreateRecipeView: View {
    @State private var recipeName = ""
    @State private var recipeLink = ""
    @State private var recipeIngredients = ""
    @State private var recipeInstructions = ""
    
    var recipe: Recipe
    
    var body: some View {
        Form {
            Section(header: Text("recipe")) {
                TextField("Enter recipe name", text: $recipeName)
                    .disableAutocorrection(true)
                TextField("Enter recipe link", text: $recipeLink)
                    .disableAutocorrection(true)
            }
            Section(header: Text("ingredients")) {
                TextField("Enter recipe ingredients", text: $recipeIngredients)
                    .disableAutocorrection(true)
                    .frame(minHeight: 100)
            }
            Section(header: Text("instructions")) {
                TextField("Enter recipe instructions", text: $recipeInstructions)
                    .disableAutocorrection(true)
                    .frame(minHeight: 100)
            }
            Section() {
                Button("Done") {}
            }
        }
    }
}

struct CreateRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRecipe = Recipe(id: "id", title: "recipe title", ingredients: [], instructions: "instructions", link: "")
        CreateRecipeView(recipe: sampleRecipe)
    }
}
