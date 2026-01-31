import SwiftUI

struct ProfileView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var age: String = ""
    @State private var statusMessage: String = ""
    
    var isValid: Bool {
        !name.isEmpty && email.contains("@") && email.contains(".") && (Int(age) ?? 0) > 0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("User Profile") {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Button("Save") { saveProfile() }
                        .disabled(!isValid)
                    Button("Clear") { clearProfile() }
                        .foregroundColor(.red)
                }
                
                if !statusMessage.isEmpty {
                    Section { Text(statusMessage).foregroundColor(.green) }
                }
            }
            .navigationTitle("Profile")
            .onAppear { loadProfile() }
        }
    }
    
    private func saveProfile() {
        let profile = UserProfile(name: name, email: email, age: Int(age) ?? 0)
        UserDefaultsStore.shared.save(profile: profile)
        statusMessage = "Saved!"
    }
    
    private func loadProfile() {
        if let profile = UserDefaultsStore.shared.load() {
            name = profile.name
            email = profile.email
            age = "\(profile.age)"
            statusMessage = "Loaded!"
        }
    }
    
    private func clearProfile() {
        UserDefaultsStore.shared.clear()
        name = ""; email = ""; age = ""
        statusMessage = "Cleared!"
    }
}

#Preview { ProfileView() }
