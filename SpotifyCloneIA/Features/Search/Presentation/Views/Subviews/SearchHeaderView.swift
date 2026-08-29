import SwiftUI

// MARK: - SearchHeaderView
/// Header view with search field for the Search screen.
struct SearchHeaderView: View {
    
    // MARK: - Properties
    
    @Binding var searchQuery: String
    let onSearch: () -> Void
    
    // Debounce task for keystrokes
    @State private var searchDebounceTask: Task<Void, Never>?
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 12) {
            // Search icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(.black)
                .font(.circular(.book, size: 20))
            
            // Search text field con placeholder personalizado en negro
            ZStack(alignment: .leading) {
                if searchQuery.isEmpty {
                    Text("What do you want to listen to?")
                        .foregroundColor(.black)
                        .font(.circular(.medium, size: 16))
                        .allowsHitTesting(false)
                }
                
                TextField("", text: $searchQuery)
                    .foregroundColor(.black) // color del texto ingresado
                    .font(.circular(.medium, size: 16))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.search)
                    .onSubmit {
                        // Immediate search on submit
                        onSearch()
                    }
                    .onChange(of: searchQuery) { _, _ in
                        // Debounce search to avoid main-thread pressure while typing
                        searchDebounceTask?.cancel()
                        searchDebounceTask = Task {
                            // Sleep off the main actor
                            try? await Task.sleep(nanoseconds: 350_000_000) // 350ms
                            // If not cancelled, trigger search
                            if !Task.isCancelled {
                                onSearch()
                            }
                        }
                    }
                    .accessibilityLabel("Search")
            }
            
            // Clear button
            if !searchQuery.isEmpty {
                Button(action: {
                    searchDebounceTask?.cancel()
                    searchQuery = ""
                    // Optionally trigger an immediate clear search
                    onSearch()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.circular(.book, size: 18))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.surfaceField)
        .cornerRadius(8)
    }
}

// MARK: - Preview

#Preview {
    SearchHeaderView(
        searchQuery: .constant(""),
        onSearch: {}
    )
    .padding()
    .background(Color.black)
}
