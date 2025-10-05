import Foundation

// MARK: - SearchRepository
/// Implementation of the SearchRepositoryProtocol.
/// This repository provides mock data for development.
/// In production, this would fetch data from an API or database.
final class SearchRepository: SearchRepositoryProtocol {
    
    // MARK: - SearchRepositoryProtocol Implementation
    
    func getSearchCategories() async throws -> [SearchCategory] {
        // Debug log for easier debugging.
        print("🔄 SearchRepository: Fetching search categories...")
        
        // Simulate network delay for development
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Mock data based on Figma design
        let categories: [SearchCategory] = [
            SearchCategory(id: "1", title: "Music", backgroundColor: "#DC148C"),
            SearchCategory(id: "2", title: "Podcast", backgroundColor: "#006450"),
            SearchCategory(id: "3", title: "Live Events", backgroundColor: "#8400E7"),
            SearchCategory(id: "4", title: "Made for You", backgroundColor: "#1E3264"),
            SearchCategory(id: "5", title: "New Releases", backgroundColor: "#E13300"),
            SearchCategory(id: "6", title: "Pop", backgroundColor: "#148EE0"),
            SearchCategory(id: "7", title: "Hipop", backgroundColor: "#BA5D07"),
            SearchCategory(id: "8", title: "Charts", backgroundColor: "#8D67AB"),
            SearchCategory(id: "9", title: "Country", backgroundColor: "#E8115B"),
            SearchCategory(id: "10", title: "Rock", backgroundColor: "#DC148C"),
            SearchCategory(id: "11", title: "Latin", backgroundColor: "#E13300"),
            SearchCategory(id: "12", title: "Workout", backgroundColor: "#777777"),
            SearchCategory(id: "13", title: "Discover", backgroundColor: "#8D67AB"),
            SearchCategory(id: "14", title: "Concert", backgroundColor: "#E8115B"),
            SearchCategory(id: "15", title: "Disney", backgroundColor: "#27856A"),
            SearchCategory(id: "16", title: "At Home", backgroundColor: "#8C67AB"),
            SearchCategory(id: "17", title: "Chill", backgroundColor: "#E80F5C"),
            SearchCategory(id: "18", title: "Indie", backgroundColor: "#B16138"),
            SearchCategory(id: "19", title: "Decades", backgroundColor: "#DC148C"),
            SearchCategory(id: "20", title: "Summer", backgroundColor: "#148EE0")
        ]
        
        // Debug log for easier debugging.
        print("✅ SearchRepository: Fetched \(categories.count) categories.")
        
        return categories
    }
    
    func getFeaturedGenres() async throws -> [Genre] {
        // Debug log for easier debugging.
        print("🔄 SearchRepository: Fetching featured genres...")
        
        // Simulate network delay for development
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Mock data based on Figma design
        let genres: [Genre] = [
            Genre(
                id: "1",
                name: "Permanent Wave",
                hashtag: "#permanent wave",
                backgroundColor: "#8D67AB"
            ),
            Genre(
                id: "2",
                name: "Madchester",
                hashtag: "#madchester",
                backgroundColor: "#E8115B"
            ),
            Genre(
                id: "3",
                name: "Dance Rock",
                hashtag: "#dance rock",
                backgroundColor: "#1E3264"
            )
        ]
        
        // Debug log for easier debugging.
        print("✅ SearchRepository: Fetched \(genres.count) genres.")
        
        return genres
    }
    
    func search(query: String) async throws -> [SearchResult] {
        // Debug log for easier debugging.
        print("🔄 SearchRepository: Searching for '\(query)'...")
        
        // Simulate network delay for development
        try await Task.sleep(nanoseconds: 800_000_000) // 0.8 seconds
        
        // Mock search results for development
        let results: [SearchResult] = [
            SearchResult(
                id: "1",
                title: "Radiohead",
                subtitle: "Artist",
                type: .artist
            ),
            SearchResult(
                id: "2",
                title: "OK Computer",
                subtitle: "Radiohead • Album",
                type: .album
            ),
            SearchResult(
                id: "3",
                title: "Paranoid Android",
                subtitle: "Radiohead • OK Computer",
                type: .track
            ),
            SearchResult(
                id: "4",
                title: "Rock Classics",
                subtitle: "Playlist • 150 songs",
                type: .playlist
            )
        ]
        
        // Debug log for easier debugging.
        print("✅ SearchRepository: Found \(results.count) results for '\(query)'.")
        
        return results
    }
}
