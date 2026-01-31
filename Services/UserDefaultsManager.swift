import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let nameKey = "user_name"
    private let emailKey = "user_email"
    private let ageKey = "user_age"
    private let profileKey = "user_profile"
    
    private init() {}
    
    func saveProfile(_ profile: UserProfile) {
        UserDefaults.standard.set(profile.name, forKey: nameKey)
        UserDefaults.standard.set(profile.email, forKey: emailKey)
        UserDefaults.standard.set(profile.age, forKey: ageKey)
        
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: profileKey)
        }
        
        print("Profile saved: \(profile.name), \(profile.email), \(profile.age)")
    }
    
    func loadProfile() -> UserProfile? {
        if let data = UserDefaults.standard.data(forKey: profileKey),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            return profile
        }
        
        let name = UserDefaults.standard.string(forKey: nameKey) ?? ""
        let email = UserDefaults.standard.string(forKey: emailKey) ?? ""
        let age = UserDefaults.standard.integer(forKey: ageKey)
        
        if !name.isEmpty || !email.isEmpty {
            return UserProfile(name: name, email: email, age: age)
        }
        
        return nil
    }
    
    func clearProfile() {
        UserDefaults.standard.removeObject(forKey: nameKey)
        UserDefaults.standard.removeObject(forKey: emailKey)
        UserDefaults.standard.removeObject(forKey: ageKey)
        UserDefaults.standard.removeObject(forKey: profileKey)
    }
}
