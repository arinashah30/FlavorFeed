import SwiftUI

struct RecipeFormView: View {
    @State private var title = ""
    @State private var ingredients = ""
    @State private var instructions = ""
    @State private var link = ""
    @State private var recipeType = "Your Own"
    @State private var isEditing = false
    @Binding var recipe: Recipe?
    @Binding var isPresentingRecipeForm: Bool
    @State private var invalid = false;
    @State private var submittedRecipes: [Recipe] = []
    var options = ["Your Own", "Online"]
    var body: some View {
        GeometryReader { geometry in

            RoundedRectangle(cornerRadius: 25.0)
                .foregroundColor(Color(.systemGray6))
                .overlay(
                    VStack {
                            ZStack {
                                Button(action: {
                                    resetForm()
                                    toggle()
                                }) {
                                    Image(systemName: "xmark.circle")
                                        .foregroundColor(Color.ffSecondary)
                                        .padding()
                                        .font(.system(size: 30)).padding(5)
                                }
                                .frame(width: geometry.size.width - 51, alignment: .trailing)
                                Spacer()
                                Text("Add Recipe")
                                    .font(.system(size: 25))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.ffSecondary)
                                    .frame(width: geometry.size.width - 51, alignment: .center)
                                
                            }
                            Picker("Tabs", selection: $recipeType) {
                                Text(options[0]).tag(options[0])
                                Text(options[1]).tag(options[1])
                            }
                            .pickerStyle(.segmented)
                            .padding(.bottom, 30)
                            .menuStyle(.borderlessButton)
                            .frame(width: geometry.size.width - 51)
                            if recipeType == "Your Own" {
                                Text("ENTER RECIPE NAME")
                                    .frame(width: geometry.size.width - 51, alignment: .leading)
                                RoundedRectangle(cornerRadius: 25.0)
                                    .foregroundColor(Color.ffTertiary)
                                    .overlay(
                                        TextField("Title", text: $title)
                                            .padding(.horizontal, 10)
                                    )
                                    .frame(width: geometry.size.width - 51, height: 40)
                                    .padding(.horizontal, 10)
                                Text("ENTER COMMA SEPERATED INGREDIENTS")
                                    .frame(width: geometry.size.width - 51, alignment: .leading)
                                RoundedRectangle(cornerRadius: 25.0)
                                    .foregroundColor(Color.ffTertiary)
                                    .overlay(
                                        TextField("Ingredients", text: $ingredients, axis: .vertical)
                                            .frame(minHeight: 100)
                                            .lineLimit(5, reservesSpace: true)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 10)
                                    )
                                    .frame(width: geometry.size.width - 51, height: 120)
                                    .padding(.horizontal, 10)
                                Text("ENTER DIRECTIONS")
                                    .frame(width: geometry.size.width - 51, alignment: .leading)
                                RoundedRectangle(cornerRadius: 25.0)
                                    .foregroundColor(Color.ffTertiary)
                                    .overlay(
                                        TextField("Instructions", text: $instructions, axis: .vertical)
                                            .frame(minHeight: 100)
                                            .lineLimit(5, reservesSpace: true)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 10)
                                    )
                                    .frame(width: geometry.size.width - 51, height: 120)
                                    .padding(.horizontal, 10)
                                HStack {
                                    Button("ADD") {
                                        validSubmitYourOwn()
                                    }
                                    .font(.system(size: 16))
                                    .bold()
                                    .foregroundColor(.white)
                                    .buttonStyle(BorderedButtonStyle())
                                    .background(Color.ffPrimary)
                                    .cornerRadius(25)
                                    .alert(isPresented: $invalid) {
                                        Alert(
                                            title: Text("Cannot submit incomplete recipe."),
                                            message: Text("Enter valid Title, Ingredients, and Instructions.")
                                        )
                                    }
                                }
                                .padding()
                                .padding()
                                if !submittedRecipes.isEmpty {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Submitted Recipes:")
                                            .font(.headline)
                                            .padding(.top, 10)
                                        ForEach(submittedRecipes, id: \.id) { submittedRecipe in
                                            Text(submittedRecipe.title)
                                            let formattedIngredients = submittedRecipe.ingredients!.map { "• \($0)" }
                                            let ingredientsText = formattedIngredients.joined(separator: "\n")
                                            Text(ingredientsText)
                                        }
                                    }
                                    .padding()
                                }
                            }
                            if recipeType == "Online" {
                                Text("ENTER RECIPE NAME")
                                    .frame(width: geometry.size.width - 51, alignment: .leading)
                                RoundedRectangle(cornerRadius: 25.0)
                                    .foregroundColor(Color.ffTertiary)
                                    .overlay(
                                        TextField("Title", text: $title)
                                            .padding(.horizontal, 10)
                                    )
                                    .frame(width: geometry.size.width - 51, height: 40)
                                    .padding(.horizontal, 10)
                                Text("ENTER LINK")
                                    .frame(width: geometry.size.width - 51, alignment: .leading)
                                RoundedRectangle(cornerRadius: 25.0)
                                    .foregroundColor(Color.ffTertiary)
                                    .overlay(
                                        TextField("Link", text: $link)
                                            .padding(.horizontal, 10)
                                    )
                                    .frame(width: geometry.size.width - 51, height: 40)
                                    .padding(.horizontal, 10)
                                HStack {
                                    Button("ADD") {
                                        validSubmitYourOwn()
                                    }
                                    .font(.system(size: 16))
                                    .bold()
                                    .foregroundColor(.white)
                                    .buttonStyle(BorderedButtonStyle())
                                    .background(Color.ffPrimary)
                                    .cornerRadius(25)
                                    .alert(isPresented: $invalid) {
                                        Alert(
                                            title: Text("Cannot submit incomplete recipe."),
                                            message: Text("Enter valid Title, and Link.")
                                        )
                                    }
                                }
                                .padding(.bottom, geometry.size.width - 125)
                                .padding()
                                if !submittedRecipes.isEmpty {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Submitted Recipes:")
                                            .font(.headline)
                                            .padding(.top, 10)
                                        ForEach(submittedRecipes, id: \.id) { submittedRecipe in
                                            Text(submittedRecipe.title)
                                            let formattedIngredients = submittedRecipe.ingredients!.map { "• \($0)" }
                                            let ingredientsText = formattedIngredients.joined(separator: "\n")
                                            Text(ingredientsText)
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                        .padding()
                )
                .frame(width: geometry.size.width - 20 , height: geometry.size.height - 20)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
            

        }
    }
    
    private func toggle() {
        isPresentingRecipeForm = false;
    }
    
    private func resetForm() {
        title = ""
        ingredients = ""
        instructions = ""
        link = ""
        recipe = nil
    }
    private func saveRecipe() {
        let newRecipe = Recipe(id: UUID().uuidString, title: title, link: link, ingredients: ingredients.components(separatedBy: ","), directions: instructions)
        recipe = newRecipe
        submittedRecipes.append(newRecipe)
        resetForm()
    }
    private func validSubmitOnline(){
        if title.isEmpty || link.isEmpty {
            invalid = true
        } else {
            saveRecipe()
            toggle()
        }
    }
    private func validSubmitYourOwn(){
        if title.isEmpty || ingredients.isEmpty || instructions.isEmpty {
            invalid = true
        } else {
            saveRecipe()
            toggle()
        }
    }
}

struct RecipeFormView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeFormView(recipe: .constant(nil), isPresentingRecipeForm:  .constant(true))
    }
}
