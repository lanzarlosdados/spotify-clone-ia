import Foundation

// MARK: - Track
/// Canonical track entity for the module. Owned by the `Player` feature and
/// reused by `Playlist` (cross-feature domain reuse, documented in
/// `docs/ARCHITECTURE.md` §8 — same rationale as `Library` reusing `HorizontalCardView`).
struct Track: Identifiable, Equatable {

    let id: String
    let title: String
    let artist: String
    let album: String?
    /// Remote artwork URL, when available.
    let coverImageURL: URL?
    /// Local asset-catalog name for artwork (mock fixtures use this).
    let coverImageName: String?
    let durationSeconds: Int
    let isExplicit: Bool

    init(
        id: String,
        title: String,
        artist: String,
        album: String? = nil,
        coverImageURL: URL? = nil,
        coverImageName: String? = nil,
        durationSeconds: Int = 0,
        isExplicit: Bool = false
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.album = album
        self.coverImageURL = coverImageURL
        self.coverImageName = coverImageName
        self.durationSeconds = durationSeconds
        self.isExplicit = isExplicit
    }
}
