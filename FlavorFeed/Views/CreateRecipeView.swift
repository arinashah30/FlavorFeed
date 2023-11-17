import SwiftUI

struct CreateRecipeView: View {
    @State private var isPresentingRecipeForm = false
    @State private var recipe: Recipe?

    var body: some View {
        VStack {            
            Button("Show Recipe Form") {
                isPresentingRecipeForm.toggle()
            }
            .sheet(isPresented: $isPresentingRecipeForm) {
                RecipeFormView(recipe: $recipe, isPresentingRecipeForm: $isPresentingRecipeForm)
            }
        }
    }
}

struct CreateRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRecipeView()
    }
}
