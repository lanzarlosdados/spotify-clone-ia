import Testing
@testable import SpotifyCloneIA

@MainActor
struct PlaybackControllerTests {

    private func track(_ id: String, duration: Int = 200) -> Track {
        Track(id: id, title: "Track \(id)", artist: "Artist", durationSeconds: duration)
    }

    @Test func loadStartsPlayingFirstTrack() {
        let controller = PlaybackController()
        controller.load(queue: [track("1"), track("2")], context: "TEST", contextTitle: "Mix")

        #expect(controller.currentTrack?.id == "1")
        #expect(controller.state.isPlaying == true)
        #expect(controller.context == "TEST")
        #expect(controller.contextTitle == "Mix")
    }

    @Test func togglePlayPauseFlipsState() {
        let controller = PlaybackController()
        controller.load(queue: [track("1")], context: "T", contextTitle: "")

        controller.togglePlayPause()
        #expect(controller.state.isPlaying == false)
        controller.togglePlayPause()
        #expect(controller.state.isPlaying == true)
    }

    @Test func nextClampsAtEndWhenRepeatOff() {
        let controller = PlaybackController()
        controller.load(queue: [track("1"), track("2")], context: "T", contextTitle: "")

        controller.next()
        #expect(controller.currentTrack?.id == "2")
        controller.next()
        #expect(controller.currentTrack?.id == "2")
        #expect(controller.state.isPlaying == false)
    }

    @Test func nextWrapsWhenRepeatContext() {
        let controller = PlaybackController()
        controller.load(queue: [track("1"), track("2")], context: "T", contextTitle: "")
        controller.cycleRepeat() // .off -> .context

        controller.next()
        controller.next()
        #expect(controller.currentTrack?.id == "1")
    }

    @Test func nextRestartsTrackWhenRepeatTrack() {
        let controller = PlaybackController()
        controller.load(queue: [track("1"), track("2")], context: "T", contextTitle: "")
        controller.seek(to: 50)
        controller.cycleRepeat() // .context
        controller.cycleRepeat() // .track

        controller.next()
        #expect(controller.currentTrack?.id == "1")
        #expect(controller.state.positionSeconds == 0)
    }

    @Test func previousRestartsWhenPastThreshold() {
        let controller = PlaybackController()
        controller.load(queue: [track("1"), track("2")], context: "T", contextTitle: "")
        controller.next()
        controller.seek(to: 10)

        controller.previous()
        #expect(controller.currentTrack?.id == "2")
        #expect(controller.state.positionSeconds == 0)
    }

    @Test func previousGoesBackWhenEarly() {
        let controller = PlaybackController()
        controller.load(queue: [track("1"), track("2")], context: "T", contextTitle: "")
        controller.next()
        controller.seek(to: 1)

        controller.previous()
        #expect(controller.currentTrack?.id == "1")
    }

    @Test func seekClampsToTrackDuration() {
        let controller = PlaybackController()
        controller.load(queue: [track("1", duration: 100)], context: "T", contextTitle: "")

        controller.seek(to: 500)
        #expect(controller.state.positionSeconds == 100)
        controller.seek(to: -10)
        #expect(controller.state.positionSeconds == 0)
    }

    @Test func cycleRepeatCyclesThreeStates() {
        let controller = PlaybackController()
        #expect(controller.state.repeatMode == .off)

        controller.cycleRepeat()
        #expect(controller.state.repeatMode == .context)
        controller.cycleRepeat()
        #expect(controller.state.repeatMode == .track)
        controller.cycleRepeat()
        #expect(controller.state.repeatMode == .off)
    }

    @Test func toggleShuffleFlips() {
        let controller = PlaybackController()
        #expect(controller.state.isShuffled == false)
        controller.toggleShuffle()
        #expect(controller.state.isShuffled == true)
    }

    @Test func toggleLikeTracksCurrentTrack() {
        let controller = PlaybackController()
        controller.load(queue: [track("1")], context: "T", contextTitle: "")

        #expect(controller.isCurrentTrackLiked == false)
        controller.toggleLike()
        #expect(controller.isCurrentTrackLiked == true)
        controller.toggleLike()
        #expect(controller.isCurrentTrackLiked == false)
    }

    @Test func seedIfNeededOnlySeedsWhenEmpty() {
        let controller = PlaybackController()
        controller.seedIfNeeded(with: track("seed"))
        #expect(controller.currentTrack?.id == "seed")

        controller.seedIfNeeded(with: track("ignored"))
        #expect(controller.currentTrack?.id == "seed")
    }
}
