import SwiftUI
import UIKit

// MARK: - SearchView
/// Main search screen view following Clean Architecture and MVVM.
/// Displays search field, featured genres, and browse categories.
struct SearchView: View {
    
    // MARK: - Properties
    
    // Using `let` for view model as per state management rules
    let viewModel: SearchViewModel
    
    // MARK: - Body
    
    var body: some View {
        // Create a bindable proxy to the @Observable view model
        @Bindable var viewModel = viewModel
        
        NavigationStack {
            ZStack {
                // Background color
                Color.backgroundApp.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Search header
                        SearchHeaderView(
                            searchQuery: $viewModel.searchQuery,
                            onSearch: {
                                Task {
                                    await viewModel.performSearch()
                                }
                            }
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        
                        // Content: either search results or browse content
                        if viewModel.showingSearchResults {
                            searchResultsSection
                        } else {
                            browseContentSection
                        }
                    }
                    .padding(.bottom, 80) // Space for player sticky
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .tint(Color.textPrimary) // Color para botones/elementos de la barra
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                // Colores de título (normal y grande)
                appearance.titleTextAttributes = [
                    .foregroundColor: UIColor(Color.textPrimary)
                ]
                appearance.largeTitleTextAttributes = [
                    .foregroundColor: UIColor(Color.textPrimary)
                ]
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
            }
            .task {
                // Load initial data when view appears
                await viewModel.loadInitialData()
            }
        }
    }
    
    // MARK: - Search Results Section
    
    @ViewBuilder
    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if viewModel.isSearching {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 40)
            } else if viewModel.searchResults.isEmpty {
                Text("No results found")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 40)
            } else {
                ForEach(viewModel.searchResults) { result in
                    SearchResultRowView(result: result)
                }
            }
        }
    }
    
    // MARK: - Browse Content Section
    
    @ViewBuilder
    private var browseContentSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Explore your musical type section
            if !viewModel.genres.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Explore your musical type")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color.textPrimary)
                        .padding(.horizontal, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.genres) { genre in
                                GenreCardView(genre: genre)
                                    .frame(width: 180)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            
            // Browse all section
            if !viewModel.categories.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Browse all")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color.textPrimary)
                        .padding(.horizontal, 16)
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ],
                        spacing: 12
                    ) {
                        ForEach(viewModel.categories) { category in
                            CategoryCardView(category: category)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            
            // Loading indicator
            if viewModel.isLoadingCategories || viewModel.isLoadingGenres {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 40)
            }
            
            // Error message
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                    .padding(.horizontal, 16)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    // Create SearchViewModel using the factory
    let viewModel = SearchFactory.shared.makeSearchViewModel()
    
    return SearchView(viewModel: viewModel)
}
