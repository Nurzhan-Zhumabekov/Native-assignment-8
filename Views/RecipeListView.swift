import SwiftUI

struct RecipeListView: View {
    @StateObject var viewModel = RecipeViewModel()
    @State private var showingAddRecipe = false
    @State private var showFavoritesOnly = false
    
    var filteredRecipes: [Recipe] {
        if showFavoritesOnly {
            return viewModel.recipes.filter { $0.isFavorite }
        } else {
            return viewModel.recipes
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Recipes...")
                } else if let error = viewModel.errorText {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else if filteredRecipes.isEmpty {
                    VStack {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text(showFavoritesOnly ? "No favorite recipes yet" : "No recipes yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                        if !showFavoritesOnly {
                            Button("Add your first recipe") {
                                showingAddRecipe = true
                            }
                            .padding()
                        }
                    }
                } else {
                    List {
                        ForEach(filteredRecipes) { recipe in
                            RecipeRow(recipe: recipe, viewModel: viewModel)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        viewModel.deleteRecipe(recipeId: recipe.id)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button {
                                        viewModel.toggleFavorite(recipe: recipe)
                                    } label: {
                                        Label(recipe.isFavorite ? "Unfavorite" : "Favorite", 
                                              systemImage: recipe.isFavorite ? "star.slash" : "star.fill")
                                    }
                                    .tint(.yellow)
                                }
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Toggle(isOn: $showFavoritesOnly) {
                        Image(systemName: showFavoritesOnly ? "star.fill" : "star")
                    }
                    .toggleStyle(.button)
                    .tint(.yellow)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddRecipe = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddRecipe) {
                AddRecipeView(viewModel: viewModel)
            }
        }
    }
}

struct RecipeRow: View {
    let recipe: Recipe
    let viewModel: RecipeViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.title)
                    .font(.headline)
                HStack {
                    Text(recipe.cuisine)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("•")
                        .foregroundColor(.secondary)
                    Text("\(recipe.prepMinutes) mins")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("•")
                        .foregroundColor(.secondary)
                    Text(recipe.difficulty)
                        .font(.subheadline)
                        .foregroundColor(difficultyColor(recipe.difficulty))
                }
            }
            
            Spacer()
            
            if recipe.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
        .padding(.vertical, 4)
    }
    
    func difficultyColor(_ difficulty: String) -> Color {
        switch difficulty {
        case "Easy": return .green
        case "Medium": return .orange
        case "Hard": return .red
        default: return .gray
        }
    }
}

#Preview {
    RecipeListView()
}
