//
//  LibraryView.swift
//  SpotifyCloneIA
//
//  Created by fabian zarate on 21/09/2025.
//
//  Main view for Your Library screen.
//  Based on Figma design: https://www.figma.com/design/GhDmj6gfdTCavm1qsNRDQJ/
//  Follows workflow: /use-custom-fonts for typography.
//

import SwiftUI

// MARK: - LibraryView
/// Main view for the Library/Collection screen.
/// Displays user's saved playlists, podcasts, artists, and albums in a grid.
struct LibraryView: View {
    
    // MARK: - Properties
    
    /// ViewModel managing library state and business logic.
    /// Using `let` instead of @State following state management rules.
    let viewModel: LibraryViewModel
    
    // MARK: - Layout Constants
    
    private let headerPadding: CGFloat = 16
    private let gridSpacing: CGFloat = 8
    private let gridColumns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    // Tamaños para HorizontalCardView en grid de 3 columnas
    // Imagen: 108x108, Card total: 108x156 (imagen + texto)
    private let libraryItemImageSize = CGSize(width: 108, height: 108)
    private let libraryItemCardSize = CGSize(width: 108, height: 156)
    
    // Altura fija para la barra de filtros (evita “saltos” de layout)
    private let filtersBarHeight: CGFloat = 44
    
    // MARK: - Initialization
    
    /// Initializes LibraryView with a ViewModel.
    /// If no ViewModel is provided, creates one using LibraryCompositionRoot.
    /// - Parameter viewModel: Optional LibraryViewModel (defaults to composition root creation)
    init(viewModel: LibraryViewModel? = nil) {
        self.viewModel = viewModel ?? LibraryCompositionRoot.shared.makeLibraryViewModel()
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background
            Color.primaryBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Filters row (altura fija para evitar reflow)
                filtersView
                    .frame(height: filtersBarHeight)
                    .padding(.horizontal, headerPadding)
                    .padding(.top, 8)
                
                // Content + overlays con animación
                ZStack {
                    // Contenido principal
                    contentView
                        .opacity(viewModel.isLoading || viewModel.errorMessage != nil ? 0 : 1)
                        .animation(.easeInOut(duration: 0.25), value: viewModel.isLoading)
                        .animation(.easeInOut(duration: 0.25), value: viewModel.errorMessage)
                    
                    // Error overlay
                    if let error = viewModel.errorMessage {
                        errorView(error)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.25), value: viewModel.errorMessage)
                    }
                    
                    // Loading overlay
                    if viewModel.isLoading {
                        loadingOverlay
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.25), value: viewModel.isLoading)
                    }
                }
            }
        }
        .navigationTitle("Your Library")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                // Avatar (placeholder for now)
                Circle()
                    .fill(Color.spotifyGreen)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text("F")
                            .font(.custom("CircularStd-Bold", size: 16))
                            .foregroundColor(.black)
                    )
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                HStack(spacing: 8) {
                    // Search button
                    Button(action: {
                        // TODO: Navigate to search
                        print("🔍 Search tapped")
                    }) {
                        Image("ico-32-search")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color.textPrimary)
                    }
                    
                    // Add button
                    Button(action: {
                        // TODO: Show add menu
                        print("➕ Add tapped")
                    }) {
                        Image("ico-32-plus")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color.textPrimary)
                    }
                }
            }
        }
        .task {
            // Load data when view appears (using .task for async support)
            await viewModel.loadLibraryItems()
        }
    }
    
    // MARK: - Filters View
    
    /// Filters row with sort option and view mode toggle.
    private var filtersView: some View {
        HStack {
            // Sort menu button
            Menu {
                ForEach(LibrarySortOption.allCases, id: \.self) { option in
                    Button(action: {
                        // Execute async changeSortOption with loading state
                        Task {
                            await viewModel.changeSortOption(to: option)
                        }
                    }) {
                        HStack {
                            Text(option.rawValue)
                            if viewModel.currentSortOption == option {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Image("ico-24-arrow-up-dw")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color.textPrimary)
                    
                    // Fijamos altura/tipografía para evitar que el label “salte”
                    Text(viewModel.currentSortOption.rawValue)
                        .font(.circular(.book, size: 14))
                        .foregroundColor(Color.textPrimary)
                        .lineLimit(1)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(minHeight: 20) // asegurar altura mínima del texto
                }
                .frame(width: 140, height: 28, alignment: .leading) // contenido alineado a la izquierda
                .contentShape(Rectangle())
            }
            
            Spacer()
            
            // View mode toggle con tamaño táctil fijo para evitar cambios de layout
            Button(action: {
                viewModel.toggleViewMode()
            }) {
                Image(systemName: viewModel.isGridView ? "square.grid.2x2" : "list.bullet")
                    .font(.system(size: 20))
                    .foregroundColor(Color.textPrimary)
                    .frame(width: 44, height: 44) // área táctil fija
                    .contentShape(Rectangle())
            }
        }
    }
    
    // MARK: - Content View
    
    /// Main content area with grid of library items.
    private var contentView: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: gridSpacing) {
                ForEach(viewModel.displayedItems) { item in
                    // Reutilizando HorizontalCardView con tamaños personalizados para grid.
                    // Tap → push del detalle de playlist; long press → pin (comportamiento previo).
                    NavigationLink(value: PlaylistRoute(id: item.id)) {
                        HorizontalCardView(
                            imageName: item.imageName,
                            title: item.title,
                            description: item.description,
                            imageSize: libraryItemImageSize,
                            cardSize: libraryItemCardSize,
                            showDescription: true
                        )
                    }
                    .buttonStyle(.plain)
                    .simultaneousGesture(
                        LongPressGesture().onEnded { _ in
                            // Debug log for easier debugging.
                            print("📌 LibraryView: Long press on item: \(item.title)")
                            Task {
                                await viewModel.togglePin(for: item.id)
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, headerPadding)
            .padding(.top, 16)
            .padding(.bottom, 100) // Space for tab bar
        }
    }
    
    // MARK: - Loading Overlay (animado)
    
    /// Overlay de carga con fondo semitransparente y transición de opacidad.
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea()
            VStack(spacing: 12) {
                ProgressView()
                    .tint(Color.spotifyGreen)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(Color.primaryBackground.opacity(0.9))
            .cornerRadius(12)
        }
        .allowsHitTesting(true) // bloquea interacción con el contenido bajo carga
    }
    
    // MARK: - Error View
    
    /// Error message view.
    /// - Parameter message: Error message to display
    private func errorView(_ message: String) -> some View {
        VStack {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(Color.textSecondary)
            Text(message)
                .font(.custom("CircularStd-Book", size: 14))
                .foregroundColor(Color.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.top, 16)
                .padding(.horizontal, 32)
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    LibraryView()
        .preferredColorScheme(.dark)
}
