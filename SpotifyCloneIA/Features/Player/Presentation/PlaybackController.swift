import Foundation

// MARK: - PlaybackController
/// Simulated playback engine. Holds the queue + `PlaybackState` and advances the
/// position with a timer (no real audio — everything stays mock, like the rest of
/// the app). A single instance is shared via `PlayerCompositionRoot`.
@Observable
final class PlaybackController {

    // MARK: - State

    private(set) var queue: [Track] = []
    private(set) var currentIndex: Int = 0
    /// e.g. "PLAYING FROM PLAYLIST".
    private(set) var context: String = ""
    /// e.g. the playlist name shown under the context label.
    private(set) var contextTitle: String = ""
    var state = PlaybackState()
    private(set) var likedTrackIDs: Set<String> = []

    private var ticker: Task<Void, Never>?
    private let tickInterval: Double = 0.5

    // MARK: - Derived

    var currentTrack: Track? {
        guard queue.indices.contains(currentIndex) else { return nil }
        return queue[currentIndex]
    }

    var isCurrentTrackLiked: Bool {
        guard let id = currentTrack?.id else { return false }
        return likedTrackIDs.contains(id)
    }

    // MARK: - Init

    init() {
        print("🏗️ PlaybackController: Initialized.")
    }

    // MARK: - Queue

    /// Replaces the queue and starts playing from `index`.
    func load(queue: [Track], startAt index: Int = 0, context: String, contextTitle: String) {
        self.queue = queue
        self.currentIndex = queue.indices.contains(index) ? index : 0
        self.context = context
        self.contextTitle = contextTitle
        state.positionSeconds = 0
        print("🎯 PlaybackController: Loaded \(queue.count) track(s) from \(context) '\(contextTitle)'.")
        play()
    }

    /// Seeds a single-track queue when the player is opened with nothing playing.
    func seedIfNeeded(with track: Track) {
        guard queue.isEmpty else { return }
        queue = [track]
        currentIndex = 0
        context = "PLAYING FROM YOUR LIBRARY"
        contextTitle = track.album ?? track.artist
        print("🌱 PlaybackController: Seeded with '\(track.title)'.")
    }

    // MARK: - Transport

    func togglePlayPause() {
        state.isPlaying ? pause() : play()
    }

    func play() {
        guard currentTrack != nil else { return }
        state.isPlaying = true
        startTicker()
        print("▶️ PlaybackController: Play.")
    }

    func pause() {
        state.isPlaying = false
        stopTicker()
        print("⏸️ PlaybackController: Pause.")
    }

    func seek(to seconds: Double) {
        let duration = Double(currentTrack?.durationSeconds ?? 0)
        state.positionSeconds = min(max(0, seconds), duration)
    }

    func next() {
        guard !queue.isEmpty else { return }

        if state.repeatMode == .track {
            state.positionSeconds = 0
            return
        }

        if currentIndex + 1 < queue.count {
            currentIndex += 1
        } else if state.repeatMode == .context {
            currentIndex = 0
        } else {
            state.positionSeconds = 0
            pause()
            return
        }
        state.positionSeconds = 0
    }

    func previous() {
        guard !queue.isEmpty else { return }

        // Restart the current track if we're more than 3s in (or already first).
        if state.positionSeconds > 3 || currentIndex == 0 {
            state.positionSeconds = 0
            return
        }
        currentIndex -= 1
        state.positionSeconds = 0
    }

    func toggleShuffle() {
        state.isShuffled.toggle()
        print("🔀 PlaybackController: Shuffle \(state.isShuffled ? "on" : "off").")
    }

    func cycleRepeat() {
        state.repeatMode = state.repeatMode.next
        print("🔁 PlaybackController: Repeat \(state.repeatMode).")
    }

    func toggleLike() {
        guard let id = currentTrack?.id else { return }
        if likedTrackIDs.contains(id) {
            likedTrackIDs.remove(id)
        } else {
            likedTrackIDs.insert(id)
        }
    }

    // MARK: - Ticker

    private func startTicker() {
        stopTicker()
        let interval = tickInterval
        ticker = Task { @MainActor [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
                guard let self else { return }
                self.tick(interval)
            }
        }
    }

    private func stopTicker() {
        ticker?.cancel()
        ticker = nil
    }

    private func tick(_ delta: Double) {
        guard state.isPlaying, let track = currentTrack else { return }
        let duration = Double(track.durationSeconds)
        let advanced = state.positionSeconds + delta
        if duration > 0 && advanced >= duration {
            next()
        } else {
            state.positionSeconds = advanced
        }
    }

    deinit {
        ticker?.cancel()
    }
}
