import Foundation

// MARK: - HomeFeed
/// Aggregates every piece of content shown on the Home screen.
struct HomeFeed: Equatable {
    let contentGrid: [ContentGridItem]
    let newRelease: NewRelease
    let yourTopMixes: [MediaCard]
    let recentlyPlayed: [MediaCard]
    let episodesForYou: [MediaCard]
    let moreLikeReference: SectionReference
    let moreLike: [MediaCard]
    let jumpBackIn: [MediaCard]
    let recommendedForToday: [MediaCard]
    let episodePreview: EpisodePreview
    let trendingAlbum: TrendingAlbum
}

// MARK: - MediaCard
/// A generic image + title + subtitle card used across the horizontal rows.
struct MediaCard: Identifiable, Equatable {
    let id: String
    let imageName: String
    let title: String
    let subtitle: String
}

// MARK: - ContentGridItem
/// Compact card for the top 2-column grid (has an optional "new content" dot).
struct ContentGridItem: Identifiable, Equatable {
    let id: String
    let imageName: String
    let title: String
    let hasNotification: Bool
}

// MARK: - NewRelease
/// "New release from <artist>" promo card.
struct NewRelease: Equatable {
    let artistName: String
    let artistImageName: String
    let releaseTitle: String
    let releaseSubtitle: String
    let artworkImageName: String
}

// MARK: - SectionReference
/// The small reference header used by the "More like:" section.
struct SectionReference: Equatable {
    let imageName: String
    let title: String
}

// MARK: - EpisodePreview
struct EpisodePreview: Equatable {
    let title: String
    let subtitle: String
    let dateText: String
    let durationText: String
    let descriptionText: String
    let artworkName: String
    let previewButtonTitle: String
}

// MARK: - TrendingAlbum
struct TrendingAlbum: Equatable {
    let title: String
    let subtitle: String
    let artworkName: String
    let backgroundImageName: String
}
