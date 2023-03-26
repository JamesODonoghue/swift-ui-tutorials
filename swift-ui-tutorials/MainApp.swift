//
//  swift_ui_tutorialsApp.swift
//  swift-ui-tutorials
//
//  Created by James O'Donoghue on 3/25/23.
//

import SwiftUI

@main
struct MainApp: App {
    
    @StateObject var spotifyController = SpotifyController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(spotifyController)
                .onOpenURL { url in
                    spotifyController.setAccessToken(from: url)
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didFinishLaunchingNotification), perform: { _ in
                    spotifyController.connect()
                })
        }
    }
}
