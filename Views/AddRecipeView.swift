import SwiftUI

struct AddRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: RecipeViewModel
    
    @State private var title: String = ""
    @State private var cuisine: String = ""
    @State private var prepMinutes: Int = 15
    @State private var difficulty: String = "Medium"
    @State private var ingredients: [String] = ["", ""]
    @State private var steps: [String] = ["", ""]
    
    let difficulties = ["Easy", "Medium", "Hard"]
    
    var isFormValid: Bool {
        !title.isEmpty && 
        !cuisine.isEmpty && 
        prepMinutes > 0 && 
        ingredients.filter { !$0.isEmpty }.count >= 2 &&
        steps.filter { !$0.isEmpty }.count >= 2
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Basic Info")) {
                    TextField("Title", text: $title)
                    TextField("Cuisine", text: $cuisine)
                    Stepper("Prep Minutes: \(prepMinutes)", value: $prepMinutes, in: 1...300)
                }
                
                Section(header: Text("Difficulty")) {
                    Picker("Difficulty", selection: $difficulty) {
                        ForEach(difficulties, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Ingredients (min 2)")) {
                    ForEach(0..<ingredients.count, id: \.self) { index in
                        TextField("Ingredient \(index + 1)", text: $ingredients[index])
                    }
                    Button("Add Ingredient") {
                        ingredients.append("")
                    }
                }
                
                Section(header: Text("Steps (min 2)")) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        TextField("Step \(index + 1)", text: $steps[index])
                    }
                    Button("Add Step") {
                        steps.append("")
                    }
                }
            }
            .navigationTitle("New Recipe")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addRecipe(
                            title: title,
                            cuisine: cuisine,
                            prepMinutes: prepMinutes,
                            difficulty: difficulty,
                            ingredients: ingredients.filter { !$0.isEmpty },
                            steps: steps.filter { !$0.isEmpty }
                        )
                        dismiss()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
}

#Preview {
    AddRecipeView(viewModel: RecipeViewModel())
}
