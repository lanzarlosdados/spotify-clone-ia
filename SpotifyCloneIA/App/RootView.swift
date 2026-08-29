//
//  RootView.swift
//  SpotifyCloneIA
//
//  Created by fabian zarate on 31/08/2025.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabBarControllerView(tabBarViewModel: TabBarViewModel())
    }
}

#Preview {
    RootView()
}
