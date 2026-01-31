import Foundation

class UnsplashService {
    static let shared = UnsplashService()
    
    // IMPORTANT: Replace with your own Unsplash Access Key
    // Get it from: https://unsplash.com/developers
    private let accessKey = "YOUR_UNSPLASH_ACCESS_KEY"
    private let baseURL = "https://api.unsplash.com"
    
    private init() {}
    
    func searchPhotos(query: String) async throws -> [UnsplashPhoto] {
        guard !query.isEmpty else { return [] }
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "\(baseURL)/search/photos?query=\(encodedQuery)&per_page=20"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let searchResult = try decoder.decode(UnsplashSearchResult.self, from: data)
        
        return searchResult.results
    }
}
