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
    var options = ["Your Own", "Online"]
    
    init(recipe: Binding<Recipe?>, isPresentingRecipeForm: Binding<Bool>) {
        self.title = recipe.wrappedValue?.title ?? ""
        self.ingredients = recipe.wrappedValue?.ingredients?.joined(separator: ",") ?? ""
        self.instructions = recipe.wrappedValue?.directions ?? ""
        self.link = recipe.wrappedValue?.link ?? ""
        self._recipe = recipe
        self._isPresentingRecipeForm = isPresentingRecipeForm
    }
    
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            GeometryReader { geometry in
                
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(Color(.systemGray6))
                    .overlay(
                        VStack {
                            ZStack {
                                Button(action: {
                                    //resetForm()
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
                                Text("ENTER COMMA SEPARATED INGREDIENTS")
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
                                    .padding()
                                    .alert(isPresented: $invalid) {
                                        Alert(
                                            title: Text("Cannot submit incomplete recipe."),
                                            message: Text("Enter valid Title, Ingredients, and Instructions.")
                                        )
                                    }
                                    
                                    Button("CLEAR") {
                                        resetForm()
                                    }.font(.system(size: 16))
                                        .bold()
                                        .foregroundColor(.white)
                                        .buttonStyle(BorderedButtonStyle())
                                        .background(Color.ffPrimary)
                                        .cornerRadius(25)
                                        .padding()
                                }
                                .padding()
                                .padding()
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
                                        validSubmitOnline()
                                    }
                                    .font(.system(size: 16))
                                    .bold()
                                    .foregroundColor(.white)
                                    .buttonStyle(BorderedButtonStyle())
                                    .background(Color.ffPrimary)
                                    .cornerRadius(25)
                                    .padding()
                                    .alert(isPresented: $invalid) {
                                        Alert(
                                            title: Text("Cannot submit incomplete recipe."),
                                            message: Text("Enter valid title and link.")
                                        )
                                    }
                                    
                                    Button("CLEAR") {
                                        resetForm()
                                    }.font(.system(size: 16))
                                        .bold()
                                        .foregroundColor(.white)
                                        .buttonStyle(BorderedButtonStyle())
                                        .background(Color.ffPrimary)
                                        .cornerRadius(25)
                                        .padding()
                                }
                                .padding(.bottom, geometry.size.width - 125)
                                .padding()
                            }
                        }
                            .padding()
                    )
                    .frame(width: geometry.size.width - 20 , height: geometry.size.height - 20)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                
                
            }
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
        recipe = Recipe(id: UUID().uuidString, title: title, link: link, ingredients: ingredients.components(separatedBy: ","), directions: instructions)
    }
    private func validSubmitOnline(){
        if title.isEmpty || link.isEmpty {
            invalid = true
        } else {
            if (recipe?.title != title && recipe?.link != link) {
                saveRecipe() //save the new recipe
            }
            toggle()
        }
    }
    private func validSubmitYourOwn(){
        if title.isEmpty || ingredients.isEmpty || instructions.isEmpty {
            invalid = true
        } else {
            if (recipe?.title != title && recipe?.ingredients?.joined(separator: ",") != ingredients && recipe?.directions != instructions) {
                saveRecipe()
            }
            toggle()
        }
    }
}

struct RecipeFormView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeFormView(recipe: Binding.constant(Recipe(id: UUID().uuidString, title: "Fruit Salad")), isPresentingRecipeForm:  Binding.constant(true))
    }
}
