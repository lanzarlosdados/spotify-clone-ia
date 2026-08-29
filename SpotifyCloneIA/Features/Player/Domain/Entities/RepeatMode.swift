import Foundation

// MARK: - RepeatMode
/// Repeat behaviour for playback, cycled by the repeat control.
enum RepeatMode: CaseIterable {
    case off
    case context
    case track

    /// Next mode in the cycle: off → context → track → off.
    var next: RepeatMode {
        switch self {
        case .off: return .context
        case .context: return .track
        case .track: return .off
        }
    }
}
