//
//  PlayerPlaylistFlowUITests.swift
//  SpotifyCloneIAUITests
//
//  Visual smoke test: Library → Playlist → Player. Captures screenshots as
//  always-kept attachments for manual review of the new screens.
//

import XCTest

final class PlayerPlaylistFlowUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    private func snapshot(_ app: XCUIApplication, _ name: String) {
        // Let any push / cover transition settle before capturing.
        Thread.sleep(forTimeInterval: 1.5)
        let shot = app.screenshot()
        let attachment = XCTAttachment(screenshot: shot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testLibraryToPlaylistToPlayer() throws {
        let app = XCUIApplication()
        app.launch()

        // Splash (2.5s) → tab bar.
        let libraryTab = app.tabBars.buttons["Your library"]
        XCTAssertTrue(libraryTab.waitForExistence(timeout: 20), "Library tab never appeared")
        libraryTab.tap()

        // Library grid loads after a simulated delay.
        let playlistCard = app.staticTexts["Rock Mix"]
        XCTAssertTrue(playlistCard.waitForExistence(timeout: 10), "Library card not found")
        snapshot(app, "01-library")

        playlistCard.tap()

        // Playlist detail.
        let believerRow = app.staticTexts["Believer"]
        XCTAssertTrue(believerRow.waitForExistence(timeout: 10), "Playlist tracks not shown")
        snapshot(app, "02-playlist")

        // Big green Play button in the header.
        let headerPlay = app.buttons["Play"].firstMatch
        XCTAssertTrue(headerPlay.waitForExistence(timeout: 5))
        headerPlay.tap()

        // Full-screen player.
        let pause = app.buttons["Pause"]
        XCTAssertTrue(pause.waitForExistence(timeout: 10), "Player did not open in playing state")
        snapshot(app, "03-player-playing")

        pause.tap()
        XCTAssertTrue(app.buttons["Play"].firstMatch.waitForExistence(timeout: 5))
        snapshot(app, "04-player-paused")

        // Skip to next track.
        app.buttons["Next track"].tap()
        snapshot(app, "05-player-next")

        // Close the player.
        app.buttons["Close player"].tap()
        XCTAssertTrue(app.staticTexts["Believer"].waitForExistence(timeout: 5), "Did not return to playlist")
    }
}
