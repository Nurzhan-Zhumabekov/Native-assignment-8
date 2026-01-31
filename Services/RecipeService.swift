import Foundation
import FirebaseDatabase

class RecipeService {
    static let shared = RecipeService()
    private let dbRef = Database.database().reference()
    private let recipesRef = Database.database().reference().child("recipes")
    
    private init() {}
    
    func addRecipe(_ recipe: Recipe) {
        let newRecipeRef = recipesRef.childByAutoId()
        newRecipeRef.setValue(recipe.toDictionary())
    }
    
    func observeRecipes(onChange: @escaping ([Recipe]) -> Void) {
        recipesRef.observe(.value) { snapshot in
            var newRecipes: [Recipe] = []
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let dict = childSnapshot.value as? [String: Any],
                   let recipe = Recipe(id: childSnapshot.key, dict: dict) {
                    newRecipes.append(recipe)
                }
            }
            
            // Sort by createdAt descending
            newRecipes.sort { $0.createdAt > $1.createdAt }
            onChange(newRecipes)
        }
    }
    
    func toggleFavorite(recipeId: String, isFavorite: Bool) {
        recipesRef.child(recipeId).child("isFavorite").setValue(isFavorite)
    }
    
    func deleteRecipe(recipeId: String) {
        recipesRef.child(recipeId).removeValue()
    }
}
