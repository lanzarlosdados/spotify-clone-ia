import Testing
@testable import SpotifyCloneIA

@MainActor
struct PlaylistViewModelTests {

    private final class StubRepository: PlaylistRepositoryProtocol {
        let result: Result<Playlist, Error>
        init(_ result: Result<Playlist, Error>) { self.result = result }
        func getPlaylist(id: String) async throws -> Playlist { try result.get() }
    }

    private struct StubError: Error {}

    private func samplePlaylist() -> Playlist {
        Playlist(
            id: "imagine-dragons-mix", title: "Imagine Dragons Mix", description: "desc",
            ownerName: "Spotify", coverImageName: "rock-mix", coverImageURL: nil,
            likesCount: 10, isDownloaded: false,
            tracks: [
                Track(id: "t1", title: "Alone", artist: "Alan Walker", durationSeconds: 161),
                Track(id: "t2", title: "Believer", artist: "Imagine Dragons", durationSeconds: 204)
            ]
        )
    }

    @Test func loadSuccessPopulatesModel() async {
        let vm = PlaylistCompositionRoot.makePlaylistViewModel(
            with: StubRepository(.success(samplePlaylist())), id: "imagine-dragons-mix"
        )

        await vm.load(id: "imagine-dragons-mix")

        #expect(vm.playlist?.title == "Imagine Dragons Mix")
        #expect(vm.playlist?.tracks.count == 2)
        #expect(vm.errorMessage == nil)
        #expect(vm.isLoading == false)
    }

    @Test func loadFailureSetsErrorAndKeepsPlaylistNil() async {
        let vm = PlaylistCompositionRoot.makePlaylistViewModel(
            with: StubRepository(.failure(StubError())), id: "x"
        )

        await vm.load(id: "x")

        #expect(vm.playlist == nil)
        #expect(vm.errorMessage != nil)
        #expect(vm.isLoading == false)
    }

    @Test func playbackQueueExposesDomainTracksInOrder() async {
        let vm = PlaylistCompositionRoot.makePlaylistViewModel(
            with: StubRepository(.success(samplePlaylist())), id: "imagine-dragons-mix"
        )

        await vm.load(id: "imagine-dragons-mix")

        #expect(vm.playbackQueue.map(\.id) == ["t1", "t2"])
    }
}
