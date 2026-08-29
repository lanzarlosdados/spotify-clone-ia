import Foundation

// MARK: - HomeFeedDTO
/// Data Transfer Object for the Home feed (matches `HomeFeed.json`).
struct HomeFeedDTO: Codable {
    let contentGrid: [ContentGridItemDTO]
    let newRelease: NewReleaseDTO
    let yourTopMixes: [MediaCardDTO]
    let recentlyPlayed: [MediaCardDTO]
    let episodesForYou: [MediaCardDTO]
    let moreLikeReference: SectionReferenceDTO
    let moreLike: [MediaCardDTO]
    let jumpBackIn: [MediaCardDTO]
    let recommendedForToday: [MediaCardDTO]
    let episodePreview: EpisodePreviewDTO
    let trendingAlbum: TrendingAlbumDTO

    enum CodingKeys: String, CodingKey {
        case contentGrid = "content_grid"
        case newRelease = "new_release"
        case yourTopMixes = "your_top_mixes"
        case recentlyPlayed = "recently_played"
        case episodesForYou = "episodes_for_you"
        case moreLikeReference = "more_like_reference"
        case moreLike = "more_like"
        case jumpBackIn = "jump_back_in"
        case recommendedForToday = "recommended_for_today"
        case episodePreview = "episode_preview"
        case trendingAlbum = "trending_album"
    }

    func toDomain() -> HomeFeed {
        HomeFeed(
            contentGrid: contentGrid.map { $0.toDomain() },
            newRelease: newRelease.toDomain(),
            yourTopMixes: yourTopMixes.map { $0.toDomain() },
            recentlyPlayed: recentlyPlayed.map { $0.toDomain() },
            episodesForYou: episodesForYou.map { $0.toDomain() },
            moreLikeReference: moreLikeReference.toDomain(),
            moreLike: moreLike.map { $0.toDomain() },
            jumpBackIn: jumpBackIn.map { $0.toDomain() },
            recommendedForToday: recommendedForToday.map { $0.toDomain() },
            episodePreview: episodePreview.toDomain(),
            trendingAlbum: trendingAlbum.toDomain()
        )
    }
}

// MARK: - Nested DTOs

struct MediaCardDTO: Codable {
    let id: String
    let imageName: String
    let title: String
    let subtitle: String

    enum CodingKeys: String, CodingKey {
        case id, title, subtitle
        case imageName = "image_name"
    }

    func toDomain() -> MediaCard {
        MediaCard(id: id, imageName: imageName, title: title, subtitle: subtitle)
    }
}

struct ContentGridItemDTO: Codable {
    let id: String
    let imageName: String
    let title: String
    let hasNotification: Bool

    enum CodingKeys: String, CodingKey {
        case id, title
        case imageName = "image_name"
        case hasNotification = "has_notification"
    }

    func toDomain() -> ContentGridItem {
        ContentGridItem(id: id, imageName: imageName, title: title, hasNotification: hasNotification)
    }
}

struct NewReleaseDTO: Codable {
    let artistName: String
    let artistImageName: String
    let releaseTitle: String
    let releaseSubtitle: String
    let artworkImageName: String

    enum CodingKeys: String, CodingKey {
        case artistName = "artist_name"
        case artistImageName = "artist_image_name"
        case releaseTitle = "release_title"
        case releaseSubtitle = "release_subtitle"
        case artworkImageName = "artwork_image_name"
    }

    func toDomain() -> NewRelease {
        NewRelease(
            artistName: artistName,
            artistImageName: artistImageName,
            releaseTitle: releaseTitle,
            releaseSubtitle: releaseSubtitle,
            artworkImageName: artworkImageName
        )
    }
}

struct SectionReferenceDTO: Codable {
    let imageName: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case title
        case imageName = "image_name"
    }

    func toDomain() -> SectionReference {
        SectionReference(imageName: imageName, title: title)
    }
}

struct EpisodePreviewDTO: Codable {
    let title: String
    let subtitle: String
    let dateText: String
    let durationText: String
    let descriptionText: String
    let artworkName: String
    let previewButtonTitle: String

    enum CodingKeys: String, CodingKey {
        case title, subtitle
        case dateText = "date_text"
        case durationText = "duration_text"
        case descriptionText = "description_text"
        case artworkName = "artwork_name"
        case previewButtonTitle = "preview_button_title"
    }

    func toDomain() -> EpisodePreview {
        EpisodePreview(
            title: title,
            subtitle: subtitle,
            dateText: dateText,
            durationText: durationText,
            descriptionText: descriptionText,
            artworkName: artworkName,
            previewButtonTitle: previewButtonTitle
        )
    }
}

struct TrendingAlbumDTO: Codable {
    let title: String
    let subtitle: String
    let artworkName: String
    let backgroundImageName: String

    enum CodingKeys: String, CodingKey {
        case title, subtitle
        case artworkName = "artwork_name"
        case backgroundImageName = "background_image_name"
    }

    func toDomain() -> TrendingAlbum {
        TrendingAlbum(
            title: title,
            subtitle: subtitle,
            artworkName: artworkName,
            backgroundImageName: backgroundImageName
        )
    }
}
