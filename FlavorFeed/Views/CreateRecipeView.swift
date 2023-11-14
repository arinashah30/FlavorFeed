//
//  CreateRecipeView.swift
//  FlavorFeed
//
//  Created by Misry Dhanani on 11/2/23.
//

import SwiftUI

struct CreateRecipeView: View {
    //@Binding var tabSelection: Tabs
    @State private var recipeName = ""
    @State private var recipeLink = ""
    @State private var recipeIngredients = ""
    @State private var recipeIngredientsList = [""]
    @State private var recipeInstructions = ""
    @State private var recipeType = "Your Own"
    @State private var isShowingSheet = false
    var options = ["Your Own", "Online"]
    var recipe: Recipe
    @State private var bool = false
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                
                VStack {
                    Button(action: {
                        isShowingSheet.toggle()
                    }) {
                        Text("Create new recipe")
                    }
                    
                    Text("recipeName: " + recipe.title)
                    Text("recipeInstructions: " + recipe.instructions)
                    Text("recipeLink: " + (recipe.link ?? "No Link"))
                }
                .sheet(isPresented: $isShowingSheet) {
                    EnterRecipeInfoView
                    VStack {
                        Spacer(minLength: 20)
                        HStack {
                            Spacer(minLength: 50)
                            Text("Add Recipe")
                            Spacer(minLength: 30)
                            Button(action: { isShowingSheet.toggle() }) {
                                Image(systemName: "xmark")
                            }.padding(.horizontal, 30)
                        }
                        Spacer(minLength: 20)
                        Picker("Tabs", selection: $recipeType) {
                            Text(options[0]).tag(options[0])
                            Text(options[1]).tag(options[1])
                        }
                        .pickerStyle(.segmented)
                        .padding(.bottom, 30)
                        .menuStyle(.borderlessButton)
                        .frame(width: geometry.size.width - 51)
                        TabView(selection: $recipeType,
                                content:  {
                            Form {
                                if recipeType == "Your Own" {
                                    Section(header: Text("recipe")) {
                                        TextField("Enter recipe name", text: $recipeName)
                                            .disableAutocorrection(true)
                                        
                                    }
                                    Section(header: Text("enter the ingredients and instructions.")) {
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
                                    Section(header: HStack {
                                        Spacer()
                                        Button(action: {
                                            didSubmitOwn()
                                            isShowingSheet.toggle()
                                        }) {
                                            Text("ADD")
                                                .font(.system(size: 16))
                                                .bold()
                                                .foregroundColor(.black)
                                        }
                                        .buttonStyle(.bordered)
                                        .background(Color.ffPrimary)
                                        .cornerRadius(25)
                                        Spacer()
                                    }
                                    ) {
                                    }
                                }
                                else {
                                    Section(header: Text("recipe")) {
                                        TextField("Enter recipe name", text: $recipeName)
                                            .disableAutocorrection(true)
                                    }
                                    Section(header: Text("link")) {
                                        TextField("Enter recipe link", text: $recipeLink)
                                            .disableAutocorrection(true)
                                    }
                                    Section(header: HStack {
                                        Spacer()
                                        Button(action: {
                                            recipe = didSubmitLink()
                                            isShowingSheet.toggle()
                                        }) {
                                            Text("ADD")
                                                .font(.system(size: 16))
                                                .bold()
                                                .foregroundColor(.black)
                                        }
                                        .buttonStyle(.bordered)
                                        .background(Color.ffPrimary)
                                        .cornerRadius(25)
                                        Spacer()
                                    }
                                    ) {
                                    }
                                }
                            }
                        })
                        .tabViewStyle(PageTabViewStyle())
                    }
                }
            }
        }
        .onAppear {
            UISegmentedControl.appearance().backgroundColor = .white
        }
    }
    
    func didCancel() {
        bool = false;
        recipeName = "";
        recipeIngredients = "";
        recipeInstructions = "";
        recipeLink = "";
    }
    func didSubmitOwn() {
        bool = true;
        let submittedRecipe = Recipe(id: "id", title: recipeName, ingredients: recipeIngredientsList, instructions: recipeInstructions, link: recipeLink)
    }
    func didSubmitLink() -> Recipe {
        bool = true;
        let submittedRecipe = Recipe(id: "id", title: recipeName, ingredients: recipeIngredientsList, instructions: recipeInstructions, link: recipeLink)
        return submittedRecipe
    }
    
}

struct CreateRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRecipe = Recipe(id: "id", title: "recipe title", ingredients: [], instructions: "instructions", link: "no link")
        CreateRecipeView(recipe: sampleRecipe)
    }
}
