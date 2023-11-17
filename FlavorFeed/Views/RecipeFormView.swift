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
            VStack {
                HStack {
                    Spacer()
                    Text("Add Recipe")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.ffSecondary)
                        .frame(maxWidth: .infinity)
                        //.background(Color.lightGray)
                    Button(action: {
                        resetForm()
                        toggle()
                    }) {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(Color.ffSecondary)
                            .padding()
                            .font(.system(size: 30)).padding(5)
                    }
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
                    TextField("Title", text: $title)
                        //.textFieldStyle(RoundedBorderTextFieldStyle())
                        //.foregroundColor(.yellow)
                        .padding()
                    Text("ENTER COMMA SEPERATED INGREDIENTS")
                    TextField("Ingredients", text: $ingredients, axis: .vertical)
                        //.background(.yellow)
                        //textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(7)
                        .padding()
                        //.frame(height: 300)
                    Spacer(minLength: 10)
                    Text("ENTER DIRECTIONS")
                    TextField("Instructions", text: $instructions, axis: .vertical)
                        //.textFieldStyle(RoundedBorderTextFieldStyle())
                        //.background(Color.ffSecondary)
                        .lineLimit(7)
                        .padding()
                    Spacer(minLength: 10)
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
                    TextField("Title", text: $title)
                        //.textFieldStyle(RoundedBorderTextFieldStyle())
                        //.foregroundColor(Color.ffSecondary)
                        .padding()
                    Text("ENTER LINK")
                    TextField("Link", text: $link)
                        //.textFieldStyle(RoundedBorderTextFieldStyle())
                        //.background(Color.ffSecondary)
                        .padding()
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
                
            }
            .background(Color(.systemGray6))
            .padding()
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
        let newRecipe = Recipe(id: UUID().uuidString, title: title, ingredients: ingredients.components(separatedBy: ","), instructions: instructions, link: link)
        recipe = newRecipe
        submittedRecipes.append(newRecipe)
        resetForm()
    }
    private func validSubmitOnline(){
        if title.isEmpty || ingredients.isEmpty || instructions.isEmpty {
            invalid = true
        } else {
            saveRecipe()
            toggle()
        }
    }
    private func validSubmitYourOwn(){
        if title.isEmpty || link.isEmpty {
            invalid = true
        } else {
            saveRecipe()
            toggle()
        }
    }
    private func errorMessage(){
        
    }
}

struct RecipeFormView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeFormView(recipe: .constant(nil), isPresentingRecipeForm:  .constant(true))
    }
}
