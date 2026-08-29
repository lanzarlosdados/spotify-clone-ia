import Testing
@testable import SpotifyCloneIA

struct PlaylistModelTests {

    private func playlist(likes: Int = 0, tracks: [Track]) -> Playlist {
        Playlist(
            id: "p", title: "Mix", description: "desc", ownerName: "Spotify",
            coverImageName: "rock-mix", coverImageURL: nil,
            likesCount: likes, isDownloaded: false, tracks: tracks
        )
    }

    @Test func metaTextFormatsLikesWithGroupingAndDuration() {
        let model = PlaylistModel(from: playlist(
            likes: 191_165,
            tracks: [
                Track(id: "1", title: "A", artist: "X", durationSeconds: 3600),
                Track(id: "2", title: "B", artist: "Y", durationSeconds: 2_700)
            ]
        ))

        #expect(model.metaText == "191,165 likes · 1h 45min")
    }

    @Test func durationTextOmitsHoursUnderAnHour() {
        #expect(PlaylistModel.durationText(180) == "3min")
        #expect(PlaylistModel.durationText(0) == "0min")
    }

    @Test func durationTextIncludesHours() {
        #expect(PlaylistModel.durationText(3_945) == "1h 5min")
    }

    @Test func mapsTracksPreservingOrder() {
        let tracks = (1...4).map { Track(id: "\($0)", title: "T\($0)", artist: "A") }
        let model = PlaylistModel(from: playlist(tracks: tracks))

        #expect(model.tracks.map(\.id) == ["1", "2", "3", "4"])
    }

    @Test func trackRowModelCarriesExplicitFlagAndDomainTrack() {
        let track = Track(id: "9", title: "Taki Taki", artist: "DJ Snake", durationSeconds: 232, isExplicit: true)
        let row = TrackRowModel(from: track)

        #expect(row.isExplicit == true)
        #expect(row.track == track)
    }
}
