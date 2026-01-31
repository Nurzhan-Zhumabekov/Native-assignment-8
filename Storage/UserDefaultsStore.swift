import Foundation

class UserDefaultsStore {
    static let shared = UserDefaultsStore()
    private let profileKey = "user_profile_data"
    private init() {}
    
    func save(profile: UserProfile) {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: profileKey)
        }
    }
    
    func load() -> UserProfile? {
        guard let data = UserDefaults.standard.data(forKey: profileKey) else { return nil }
        return try? JSONDecoder().decode(UserProfile.self, from: data)
    }
    
    func clear() {
        UserDefaults.standard.removeObject(forKey: profileKey)
    }
}
