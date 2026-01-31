import Foundation
import Combine

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorText: String? = nil
    
    private let service = RecipeService.shared
    
    init() {
        fetchRecipes()
    }
    
    func fetchRecipes() {
        isLoading = true
        errorText = nil
        
        service.observeRecipes { [weak self] fetchedRecipes in
            guard let self = self else { return }
            self.recipes = fetchedRecipes
            self.isLoading = false
        }
    }
    
    func addRecipe(title: String, cuisine: String, prepMinutes: Int, difficulty: String, ingredients: [String], steps: [String]) {
        let newRecipe = Recipe(
            title: title,
            cuisine: cuisine,
            prepMinutes: prepMinutes,
            difficulty: difficulty,
            ingredients: ingredients,
            steps: steps
        )
        service.addRecipe(newRecipe)
    }
    
    func toggleFavorite(recipe: Recipe) {
        service.toggleFavorite(recipeId: recipe.id, isFavorite: !recipe.isFavorite)
    }
    
    func deleteRecipe(recipeId: String) {
        service.deleteRecipe(recipeId: recipeId)
    }
}
