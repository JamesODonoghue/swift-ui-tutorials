import SwiftUI
import Combine
import SpotifyWebAPI

@main
struct MainApp: App {
    
//    @StateObject var spotifyController = SpotifyController()
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environmentObject(spotifyController)
//                .onOpenURL { url in
//                    spotifyController.setAccessToken(from: url)
//                }
//                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didFinishLaunchingNotification), perform: { _ in
//                    spotifyController.connect()
//                })
//        }
//    }
    
//    @StateObject var spotifyController = SpotifyController()
    
    @StateObject var spotify = Spotify()
    @StateObject var sdkController = SpotifyController()


    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(spotify)
                .environmentObject(sdkController)
        }
    }
}
